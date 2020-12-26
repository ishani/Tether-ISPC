// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// Based on Syoyo Fujita's aobench: http://code.google.com/p/aobench
// Based on the AOBENCH sample that ships with ISPC, Copyright (c) 2010-2011, Intel Corporation
//

#include "common.isph"

#define NAO_SAMPLES         8

struct Isect 
{
    float      t;
    float3     p;
    float3     n;
    int        hit;
};

struct Sphere 
{
    float3     center;
    float      radius;
};

struct Plane 
{
    float3    p;
    float3    n;
};

struct Ray 
{
    float3  org;
    float3  dir;
};

static void
ray_plane_intersect(Isect &isect, const Ray &ray, uniform const Plane &plane) 
{
    float d = -dot(plane.p, plane.n);
    float v = dot(ray.dir, plane.n);

    cif ( STDN abs(v) < 1.0e-17f )
        return;
    else {
        float t = -(dot(ray.org, plane.n) + d) / v;

        cif ((t > 0.0f) && (t < isect.t)) 
        {
            isect.t = t;
            isect.hit = 1;
            isect.p = ray.org + ray.dir * t;
            isect.n = plane.n;
        }
    }
}

static inline void
ray_sphere_intersect(Isect &isect, const Ray &ray, uniform const Sphere &sphere) 
{
    float3 rs = ray.org - sphere.center;

    float B = dot(rs, ray.dir);
    float C = dot(rs, rs) - sphere.radius * sphere.radius;
    float D = B * B - C;

    cif (D > 0.0f) {
        float t = -B - STDN sqrt(D);

        cif ((t > 0.0) && (t < isect.t)) {
            isect.t = t;
            isect.hit = 1;
            isect.p = ray.org + t * ray.dir;
            isect.n = isect.p - sphere.center;
            normalize(isect.n);
        }
    }
}


static void
orthoBasis(float3 basis[3], float3 n) 
{
    basis[2] = n;
    basis[1].x = 0.0;
    basis[1].y = 0.0;
    basis[1].z = 0.0;

    if ((n.x < 0.6) && (n.x > -0.6)) 
    {
        basis[1].x = 1.0;
    } 
    else if ((n.y < 0.6) && (n.y > -0.6)) 
    {
        basis[1].y = 1.0;
    } 
    else if ((n.z < 0.6) && (n.z > -0.6)) 
    {
        basis[1].z = 1.0;
    } 
    else 
    {
        basis[1].x = 1.0;
    }

    basis[0] = cross(basis[1], basis[2]);
    normalize(basis[0]);

    basis[1] = cross(basis[2], basis[0]);
    normalize(basis[1]);
}


static float
ambient_occlusion(
    Isect &isect, 
    uniform const Plane &plane, 
    uniform const Sphere spheres[4],
    uint32_t& rngSeed ) 
{
    float eps = 0.0001f;
    float3 p, n;
    float3 basis[3];
    float occlusion = 0.0;

    p = isect.p + eps * isect.n;

    orthoBasis(basis, isect.n);

    static const uniform int ntheta = NAO_SAMPLES;
    static const uniform int nphi   = NAO_SAMPLES;
    for (uniform int j = 0; j < ntheta; j++) {
        for (uniform int i = 0; i < nphi; i++) {
            Ray ray;
            Isect occIsect;

            rngSeed = rngScramble32( rngSeed );
            float theta = STDN sqrt( rngFloat( rngSeed ) );

            rngSeed = rngScramble32( rngSeed );
            float phi   = 2.0f * C_PI * rngFloat( rngSeed );

            float x = STDN cos(phi) * theta;
            float y = STDN sin(phi) * theta;
            float z = STDN sqrt(1.0f - theta * theta);

            // local . global
            float rx = x * basis[0].x + y * basis[1].x + z * basis[2].x;
            float ry = x * basis[0].y + y * basis[1].y + z * basis[2].y;
            float rz = x * basis[0].z + y * basis[1].z + z * basis[2].z;

            ray.org = p;
            ray.dir.x = rx;
            ray.dir.y = ry;
            ray.dir.z = rz;

            occIsect.t   = 1.0e+17f;
            occIsect.hit = 0;

            for (uniform int snum = 0; snum < 4; ++snum)
                ray_sphere_intersect(occIsect, ray, spheres[snum]);

            ray_plane_intersect (occIsect, ray, plane);

            if (occIsect.hit) 
                occlusion += 1.0f;
        }
    }

    occlusion = (ntheta * nphi - occlusion) / (float)(ntheta * nphi);
    return occlusion;
}

// tether edit to patch this to compile in serial mode
#ifdef TETHER_COMPILE_SERIAL

#define tiled_iteration_scans( _type, _yStart, _yEnd, _width, _subsamples )     \
            for (int y = _yStart; y < _yEnd; ++y)                               \
                for (int x = 0; x < _width; ++x)                                \
                    for (int u = 0; u < _subsamples; ++u)                       \
                        for (int v = 0; v < _subsamples; ++v)

#define programIndex    (0)
#define atomic_add_local( _to, _value ) *_to += _value;

#else

#define tiled_iteration_scans( _type, _yStart, _yEnd, _width, _subsamples )     \
            foreach_tiled( y = _yStart ... _yEnd,                               \
                           x = 0 ... _width,                                    \
                           u = 0 ... _subsamples,                               \
                           v = 0 ... _subsamples)

#endif

/* Compute the image for the scanlines from [y0,y1), for an overall image
   of width w and height h.
 */
static void ao_scanlines(uniform const int y0, uniform const int y1, uniform const int w,
                         uniform const int h,  uniform const int nsubsamples,
                         uniform float image[]) 
{
    ispc_construct( static const uniform float3 f3_000, { 0.0f, 0.0f, 0.0f } );

    ispc_construct( static const uniform Plane plane, { _ctf3{ 0.0f, -0.5f, 0.0f }, _ctf3{ 0.f, 1.f, 0.f } } );
    ispc_construct( static const uniform Sphere spheres[4], 
    {
        { _ctf3{ -2.0f,  0.0f, -3.5f }, 0.5f },
        { _ctf3{ -0.5f,  0.0f, -3.0f }, 0.75f },
        { _ctf3{ 1.0f,   0.0f, -2.2f }, 1.25f },
        { _ctf3{ -1.5f, -0.4f, -1.6f }, 0.3f } 
    });

    uint32_t rngstate = rngScramble32( (uint32_t)( 1 + programIndex + (y0 << (programIndex & 15)) ) );

    const uniform float invSamples = 1.f / nsubsamples;

    tiled_iteration_scans( int, y0, y1, w, nsubsamples) 
    {
        float du = (float)u * invSamples, dv = (float)v * invSamples;

        // Figure out x,y pixel in NDC
        float px =  (x + du - (w / 2.0f)) / (w / 2.0f);
        float py = -(y + dv - (h / 2.0f)) / (h / 2.0f);

        // Scale NDC based on width/height ratio, supporting non-square image output
        px *= (float)w / (float)h;

        float ret = 0.f;
        Isect isect;

        // Poor man's perspective projection
        ispc_construct( Ray ray, 
        {
            f3_000,
            _ctf3 { px, py, -1.25f }
        });
        normalize(ray.dir);

        isect.t   = 1.0e+17f;
        isect.hit = 0;

        for (uniform int snum = 0; snum < 4; ++snum)
            ray_sphere_intersect(isect, ray, spheres[snum]);

        ray_plane_intersect(isect, ray, plane);

        // Note use of 'coherent' if statement; the set of rays we
        // trace will often all hit or all miss the scene
        cif (isect.hit) 
        {
            ret = ambient_occlusion(isect, plane, spheres, rngstate);
            ret *= invSamples * invSamples;

            int offset = (y * w + x);
            atomic_add_local(&image[offset], ret);
        }
    }
}

export void renderImageAmbientOcclusion(
    uniform const int output_width, 
    uniform const int output_height, 
    uniform const int nsubsamples,
    uniform float image[]) 
{
    ao_scanlines(0, output_height, output_width, output_height, nsubsamples, image);
}
