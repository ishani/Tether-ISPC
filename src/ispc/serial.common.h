// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// replacing the common.isph configuration header with setup required to compile ISPC code as regular serial C++
// NOTE this isn't an exhaustive emulation layer, there are keywords and functions that ISPC has that are not supported yet
//

#define NOMINMAX

// configure compilation to ignore common.isph or other default includes in .ispc files, as we are replacing their
// function with C++ variants
#define TETHER_COMPILE_SERIAL

#define TETHER_SERIAL_NAMESPACE_OPEN    namespace serial {
#define TETHER_SERIAL_NAMESPACE_CLOSE   }


#include <cstdlib>
#include <cmath>
#include <cfloat>
#include <cassert>
#include <algorithm>
#include <inttypes.h>
#include <memory>
#include <string.h>

using int64     = int64_t;
using uint      = uint32_t;
using uint64    = uint64_t;


// ---------------------------------------------------------------------------------------------------------------------
// emulate ISPC vector and matrix types
//

#include <swizzle/glsl/naive/vector.h>

using float2 = swizzle::glsl::naive::vector< float, 2 >;
using float3 = swizzle::glsl::naive::vector< float, 3 >;
using float4 = swizzle::glsl::naive::vector< float, 4 >;

using int2   = swizzle::glsl::naive::vector< int, 2 >;
using int3   = swizzle::glsl::naive::vector< int, 3 >;
using int4   = swizzle::glsl::naive::vector< int, 4 >;

using uint2  = swizzle::glsl::naive::vector< uint, 2 >;
using uint3  = swizzle::glsl::naive::vector< uint, 3 >;
using uint4  = swizzle::glsl::naive::vector< uint, 4 >;

using bool2  = swizzle::glsl::naive::vector< bool, 2 >;
using bool3  = swizzle::glsl::naive::vector< bool, 3 >;
using bool4  = swizzle::glsl::naive::vector< bool, 4 >;

static_assert(sizeof(float2) == sizeof(float[2]), "float2 is not expected size");
static_assert(sizeof(float3) == sizeof(float[3]), "float3 is not expected size");
static_assert(sizeof(float4) == sizeof(float[4]), "float4 is not expected size");


#define MATRIX_BRACKET( _max )                                  \
    inline float##_max operator [] (const uint32_t idx) const   \
    {                                                           \
        if ( idx < _max )                                       \
            return row[ idx ];                                  \
        assert(0 && "idx out of bounds:" #_max); abort();       \
    }                                                           \
    inline float##_max& operator [] (const uint32_t idx)        \
    {                                                           \
        if ( idx < _max )                                       \
            return row[ idx ];                                  \
        assert(0 && "idx out of bounds:" #_max); abort();       \
    }

struct float2x2
{
    float2 row[2];

    inline float2x2(const float2& r0, const float2& r1)
    {
        row[0] = r0;
        row[1] = r1;
    }

    inline float2x2() = default;

    MATRIX_BRACKET(2);
};

struct float3x3
{
    float3 row[3];

    inline float3x3(const float3& r0, const float3& r1, const float3& r2)
    {
        row[0] = r0;
        row[1] = r1;
        row[2] = r2;
    }

    inline float3x3() = default;

    MATRIX_BRACKET(3);
};

struct float4x4
{
    float4 row[4];

    inline float4x4(const float4& r0, const float4& r1, const float4& r2, const float4& r3)
    {
        row[0] = r0;
        row[1] = r1;
        row[2] = r2;
        row[3] = r3;
    }

    inline float4x4() = default;

    MATRIX_BRACKET(4);
};

#undef MATRIX_BRACKET



// ---------------------------------------------------------------------------------------------------------------------
// custom RNG functions - ported from the ISPC standard library 
// they are not particularly fast; there is a simpler one in common.random.inl.isph (but still with good distribution)

inline float floatbits(const uint32_t u32)
{
    float ret;
    memcpy(&ret, &u32, sizeof(float));
    return ret;
}

struct RNGState 
{
    uint32_t z1, z2, z3, z4;
};

inline void seed_rng(RNGState* state, uint32_t seed) 
{
    state->z1 = seed;
    state->z2 = seed ^ 0xbeeff00d;
    state->z3 = ((seed & 0xfffful) << 16) | (seed >> 16);
    state->z4 = (((seed & 0xfful) << 24) | ((seed & 0xff00ul) << 8) |
                ((seed & 0xff0000ul) >> 8) | (seed & 0xff000000ul) >> 24);
}

inline uint32_t random(RNGState* state)
{
    uint32_t b;

    b         = ((state->z1 << 6) ^ state->z1) >> 13;
    state->z1 = ((state->z1 & 4294967294U) << 18) ^ b;
    b         = ((state->z2 << 2) ^ state->z2) >> 27;
    state->z2 = ((state->z2 & 4294967288U) << 2) ^ b;
    b         = ((state->z3 << 13) ^ state->z3) >> 21;
    state->z3 = ((state->z3 & 4294967280U) << 7) ^ b;
    b         = ((state->z4 << 3) ^ state->z4) >> 12;
    state->z4 = ((state->z4 & 4294967168U) << 13) ^ b;
    return (state->z1 ^ state->z2 ^ state->z3 ^ state->z4);
}

inline float frandom(RNGState* state)
{
    uint32_t irand  = random(state);
             irand &= (1ul << 23) - 1;

    return floatbits(0x3F800000 | irand) - 1.0f;
}


// ---------------------------------------------------------------------------------------------------------------------
// remove or replace a few bespoke keywords

#define export
#define uniform
#define cif(...)    if(__VA_ARGS__)

#define reduce_add
#define reduce_min
#define reduce_max

#define tiled_iteration_xy( _type, _width, _height )        \
            for ( _type y = (_type)0; y < _height; y ++ )   \
            for ( _type x = (_type)0; x < _width; x ++ )


// ---------------------------------------------------------------------------------------------------------------------
// construction syntax differs just enough to be annoying, which is why we use macros to wrap and adapt it; more details 
// in common.isph

#define _ctf2  float2
#define _ctf3  float3
#define _ctf4  float4

#define ispc_construct( _decl, ... )            _decl __VA_ARGS__
#define ispc_construct_struct( _decl, ... )     _decl __VA_ARGS__
#define ispc_convert( _toType, _var )           _toType(_var)

#define ispc_construct_float3_single( _decl, _value )    _decl { _value, _value, _value }
#define ispc_construct_float4_single( _decl, _value )    _decl { _value, _value, _value, _value }


// ---------------------------------------------------------------------------------------------------------------------
// define any missing stdlib functions that are considered built-in during common.isph

#define _fmax           std::max
#define _fmin           std::min

// used in _PER_CHANNEL_IMPL, which expects to refer to std:: implementations
namespace std 
{
    inline float rcp(const float v)     { return 1.0f / v; }
    inline float rsqrt(const float v)   { return 1.0f / sqrtf(v); }
}

inline void sincos(const float t, float* out_sin, float* out_cos)
{
    *out_sin = std::sin(t);
    *out_cos = std::cos(t);
}

template<class T>
constexpr const T& clamp(const T& v, const T& lo, const T& hi)
{
    return (v < lo) ? lo : (hi < v) ? hi : v;
}


// ---------------------------------------------------------------------------------------------------------------------

#include "common.macro.inl.isph"

// ---------------------------------------------------------------------------------------------------------------------

#define _TETHER_ONE_PASS   1
#define _TETHER_ARG_0      1
#define _TETHER_ARG_1      1
#define _TETHER_ARG_2      1
#define _TETHER_ARG_3      1

#define _tether_decl        static inline
#define _tether_var         
#define _tether_arg1_decl   
#define _tether_arg2_decl   
#define _tether_arg3_decl   

#define _tether_arg1(_t)        const _tether_arg1_decl _t&
#define _tether_arg2(_t)        const _tether_arg2_decl _t&
#define _tether_arg3(_t)        const _tether_arg3_decl _t&

#define _tether_arg1_float      const _tether_arg1_decl float
#define _tether_arg2_float      const _tether_arg2_decl float
#define _tether_arg3_float      const _tether_arg3_decl float

#define _tether_arg1_double     const _tether_arg1_decl double
#define _tether_arg2_double     const _tether_arg2_decl double
#define _tether_arg3_double     const _tether_arg3_decl double

#include "common.math.inl.isph"
#include "common.matrix.inl.isph"
#include "common.random.inl.isph"
#include "common.noise.inl.isph"
#include "common.utility.inl.isph"
#include "common.sdf.inl.isph"
#include "common.audio.inl.isph"



// ---------------------------------------------------------------------------------------------------------------------
// 
inline float3 gradient_turbo( const float  t )
{
    ispc_construct( static uniform const float3 c0, { 0.0002189403691192265f, 0.001651004631001012f, -0.01948089843709184f } );
    ispc_construct( static uniform const float3 c1, { 0.1065134194856116f,    0.5639564367884091f,    3.932712388889277f } );
    ispc_construct( static uniform const float3 c2, { 11.60249308247187f,     -3.972853965665698f,   -15.9423941062914f } );
    ispc_construct( static uniform const float3 c3, { -41.70399613139459f,     17.43639888205313f,     44.35414519872813f } );
    ispc_construct( static uniform const float3 c4, { 77.162935699427f,      -33.40235894210092f,    -81.80730925738993f } );
    ispc_construct( static uniform const float3 c5, { -71.31942824499214f,     32.62606426397723f,     73.20951985803202f } );
    ispc_construct( static uniform const float3 c6, { 25.13112622477341f,    -12.24266895238567f,    -23.07032500287172f } );

    return saturate( c0 + t * (c1 + t * (c2 + t * (c3 + t * (c4 + t * (c5 + t * c6))))) );
}

inline uint32_t gradient_turbo_u32( const float  t )
{
    return rgbFloatToU32( gradient_turbo( t ) );
}

// ---------------------------------------------------------------------------------------------------------------------
// 
inline float3 gradient_viridis( const float  t )
{
    ispc_construct( static uniform const float3 c0, { 0.2777273272234177f,  0.005407344544966578f,  0.3340998053353061f } );
    ispc_construct( static uniform const float3 c1, { 0.1050930431085774f,  1.404613529898575f,     1.384590162594685f } );
    ispc_construct( static uniform const float3 c2, { -0.3308618287255563f,  0.214847559468213f,     0.09509516302823659f } );
    ispc_construct( static uniform const float3 c3, { -4.634230498983486f,  -5.799100973351585f,   -19.33244095627987f } );
    ispc_construct( static uniform const float3 c4, { 6.228269936347081f,  14.17993336680509f,     56.69055260068105f } );
    ispc_construct( static uniform const float3 c5, { 4.776384997670288f, -13.74514537774601f,    -65.35303263337234f } );
    ispc_construct( static uniform const float3 c6, { -5.435455855934631f,   4.645852612178535f,    26.3124352495832f } );

    return (c0 + t * (c1 + t * (c2 + t * (c3 + t * (c4 + t * (c5 + t * c6))))));
}

inline uint32_t gradient_viridis_u32( const float  t )
{
    return rgbFloatToU32( gradient_viridis( t ) );
}

// ---------------------------------------------------------------------------------------------------------------------
// https://www.shadertoy.com/view/3dByzK
//
inline float3 gradient_rainbow( float  t )
{
    t *= 6.283185307179586f;
    ispc_construct( uniform const float2 cs1, { cosf( t ), sinf( t ) } );
    ispc_construct( uniform const float2 cs2, { cosf( 2.0f * t ), sinf( 2.0f * t ) } );


    ispc_construct( static uniform const float3 v0, { 0.4499723076135584f,  0.609426607533859f,   0.4288887656855271f } );
    ispc_construct( static uniform const float3 v1, { 1.356958715978088f,  -0.6223492834243289f, -0.2455749072607498f } );
    ispc_construct( static uniform const float3 v2, { -0.2058207830435541f,  0.4820199928163624f, -0.8671833275731918f } );
    ispc_construct( static uniform const float3 v3, { -0.2862391770341579f,  0.05434355975084173f, 0.4356605836093163f } );
    ispc_construct( static uniform const float3 v4, { -0.5279746052180661f, -0.1719661920391326f, -0.2836479508431202f } );


    ispc_construct( static uniform const float3 r0, { 1.0f,                 1.0f,                 1.0f } );
    ispc_construct( static uniform const float3 r1, { 0.7153502777378531f, -0.9219020024148035f, -0.2910109117528888f } );
    ispc_construct( static uniform const float3 r2, { -0.3381133734426577f,  0.7903005432576772f, -0.3172368432843283f } );
    ispc_construct( static uniform const float3 r3, { -0.2639897520454177f,  0.06346650999193199f, 0.5784878335459051f } );
    ispc_construct( static uniform const float3 r4, { -0.3066564712099898f, -0.2161956627263612f, -0.2188031991633754f } );

    uniform float3 n = v0;
    n += (v1 * cs1.x);
    n += (v2 * cs1.y);
    n += (v3 * cs2.x);
    n += (v4 * cs2.y); 
        
    uniform float3 d = r0;
    d += (r1 * cs1.x);
    d += (r2 * cs1.y);
    d += (r3 * cs2.x);
    d += (r4 * cs2.y);

    float3 result = n / d;

    return result;
}

inline uint32_t gradient_rainbow_u32( const float  t )
{
    return rgbFloatToU32( gradient_rainbow( t ) );
}


// ---------------------------------------------------------------------------------------------------------------------
// https://www.shadertoy.com/view/3dByzK
//
inline  float3 gradient_pastel( const  float  t )
{
    ispc_construct( uniform const float2 cs1, { cos( 1.0f * t * 6.283185307179586f ), sin( 1.0f * t * 6.283185307179586f ) } );
    ispc_construct( uniform const float2 cs2, { cos( 2.0f * t * 6.283185307179586f ), sin( 2.0f * t * 6.283185307179586f ) } );


    ispc_construct( static uniform const float3 v0, { 0.6698260593431076f,   0.5741866585654442f,    0.6074284221076398f } );
    ispc_construct( static uniform const float3 v1, { 0.8263467981452095f,  -0.2020418406514409f,   -0.06579882943043414f } );
    ispc_construct( static uniform const float3 v2, { 0.1278739528808921f,   0.2055033211946446f,   -0.4912381708231384f } );
    ispc_construct( static uniform const float3 v3, { 0.1580550606222037f,  -0.002035314944658304f, -0.03683228443676777f } );
    ispc_construct( static uniform const float3 v4, { 0.05270503006417088f, -0.01747401166680522f,   0.01104082480565293f } );


    ispc_construct( static uniform const float3 r0, { 1.0f,                  1.0f,                   1.0f } );
    ispc_construct( static uniform const float3 r1, { 1.045501814882021f,   -0.227676649398989f,    -0.07644732041559271f } );
    ispc_construct( static uniform const float3 r2, { 0.2273682478445634f,   0.3236347287584649f,   -0.4813798195577666f } );
    ispc_construct( static uniform const float3 r3, { 0.0975546708844913f,  -0.009724725764886694f,  0.004645741124919443f } );
    ispc_construct( static uniform const float3 r4, { 0.06757418348606457f, -0.01672661576390289f,   0.002341600573231208f } );

    uniform float3 n = v0 + (v1 * cs1.x) + (v2 * cs1.y) + (v3 * cs2.x) + (v4 * cs2.y);
    uniform float3 d = r0 + (r1 * cs1.x) + (r2 * cs1.y) + (r3 * cs2.x) + (r4 * cs2.y);

    return n / d;
}

inline  uint32_t gradient_pastel_u32( const  float  t )
{
    return rgbFloatToU32( gradient_rainbow( t ) );
}


#undef _tether_arg3_double
#undef _tether_arg2_double
#undef _tether_arg1_double

#undef _tether_arg3_double
#undef _tether_arg2_double
#undef _tether_arg1_double

#undef _tether_arg3
#undef _tether_arg2
#undef _tether_arg1

#undef _tether_arg3_decl
#undef _tether_arg2_decl
#undef _tether_arg1_decl
#undef _tether_var
#undef _tether_decl

#undef _TETHER_ARG_3
#undef _TETHER_ARG_2
#undef _TETHER_ARG_1
#undef _TETHER_ARG_0
#undef _TETHER_ONE_PASS

