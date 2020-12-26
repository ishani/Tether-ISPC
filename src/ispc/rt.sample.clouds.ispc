// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// ISPC port of iq Clouds shader; https://www.shadertoy.com/view/XslGRr
// 

#include "common.isph"

// defines mapping glsl types
#include "glsl.isph"


// ------------------------------------------------------------------------------------------------

ispc_construct( static const float3 v3_noise_offset, { 0.0f, 0.1f, 1.0f } );
static float iTime = 0.0f;

float map5( const vec3& p )
{
    vec3 q = p - v3_noise_offset * iTime;
    float f;
    f  = 0.50000f * perlin3D( q ); q = q * 2.02f;
    f += 0.25000f * perlin3D( q ); q = q * 2.03f;
    f += 0.12500f * perlin3D( q ); q = q * 2.01f;
    f += 0.06250f * perlin3D( q ); q = q * 2.02f;
    f += 0.03125f * perlin3D( q );
    return saturate( 1.5f - p.y - 1.8f + 3.0f * f );
}

float map4( const vec3& p )
{
    vec3 q = p - v3_noise_offset * iTime;
    float f;
    f  = 0.50000f * perlin3D( q ); q = q * 2.02f;
    f += 0.25000f * perlin3D( q ); q = q * 2.03f;
    f += 0.12500f * perlin3D( q ); q = q * 2.01f;
    f += 0.06250f * perlin3D( q );
    return saturate( 1.5f - p.y - 1.8f + 3.0f * f );
}

float map3( const vec3& p )
{
    vec3 q = p - v3_noise_offset * iTime;
    float f;
    f  = 0.50000f * perlin3D( q ); q = q * 2.02f;
    f += 0.25000f * perlin3D( q ); q = q * 2.03f;
    f += 0.12500f * perlin3D( q );
    return saturate( 1.5f - p.y - 1.8f + 3.0f * f );
}

float map2( const vec3& p )
{
    vec3 q = p - v3_noise_offset * iTime;
    float f;
    f  = 0.50000f * perlin3D( q ); q = q * 2.02f;
    f += 0.25000f * perlin3D( q );
    return saturate( 1.5f - p.y - 1.8f + 3.0f * f );
}

ispc_construct( static const float3 v3_sundir,        { 0.7f,   0.0f,   0.7f  } );
ispc_construct( static const float3 v3_sunglare,      { 1.0f,   0.4f,   0.2f  } );
ispc_construct( static const float3 v3_light_lin1,    { 0.65f,  0.7f,   0.75f } );
ispc_construct( static const float3 v3_light_lin2,    { 1.0f,   0.6f,   0.3f  } );
ispc_construct( static const float3 v3_light_fog2,    { 1.0f,   0.5f,   1.0f  } );
ispc_construct( static const float3 v3_light_lin3,    { 1.0f,   0.6f,   0.1f  } );
ispc_construct( static const float3 v3_colour_1,      { 1.0f,   0.95f,  0.8f  } );
ispc_construct( static const float3 v3_colour_2,      { 0.25f,  0.3f,   0.35f } );

#define MARCH(STEPS,MAPLOD)                                                         \
for(uniform int i=0; i<STEPS; i++)                                                  \
{                                                                                   \
   vec3 pos = ro + rd * t;                                                          \
   if ( pos.y < -3.0f || pos.y > 2.0f || sum.w > 0.99f ) break;                     \
   float den = MAPLOD( pos );                                                       \
   if ( den > 0.01f )                                                               \
   {                                                                                \
     float dif = saturate( (den - MAPLOD(pos + v3_sundir * 0.25f) ) / 0.5f );       \
     vec3 lin  = ( v3_light_lin1 * 1.5f ) + ( v3_light_lin2 * dif );                \
     vec3 cola = lerp( v3_colour_1, v3_colour_2, den );                             \
                                                                                    \
     cola *= lin;                                                                   \
     cola = lerp( cola, bgcol, 1.0f - STDN exp(-0.003f * t * t) );                  \
                                                                                    \
     float calpha = den * 0.25f;                                                    \
     ispc_construct( float4 col, { cola.x * calpha, cola.y * calpha, cola.z * calpha, calpha } ); \
                                                                                    \
     sum += col * ( 1.0f - sum.w );                                                 \
   }                                                                                \
                                                                                    \
   t += _fmax( 0.04f, 0.02f * t );                                                  \
}

vec4 raymarch( const uniform vec3& ro, const vec3& rd, const vec3& bgcol )
{
    ispc_construct( float4 sum, { 0.0f, 0.0f, 0.0f, 0.0f } );

    float t = 0.0;

    MARCH( 50, map5 );
    MARCH( 50, map4 );
    MARCH( 40, map3 );
    MARCH( 30, map2 );

    return saturate( sum );
}

uniform float3x3 setCamera( const uniform vec3& ro, const uniform vec3& ta, const uniform float cr )
{
    uniform vec3 cw = normalized(ta - ro);
    ispc_construct( uniform float3 cp, { STDN sin(cr), STDN cos(cr), 0.0f } );

    uniform vec3 cu = normalized( cross(cw, cp) );
    uniform vec3 cv = normalized( cross(cu, cw) );

    ispc_construct_struct( uniform float3x3 ret, { cu, cv, cw } );
    return ret;
}

vec4 render( const uniform vec3& ro, const vec3& rd )
{
    // background sky
    float sun = saturate( dot(v3_sundir, rd) );
    vec3 col = v3_light_lin1 - v3_light_fog2 * rd.y * 0.2f;

    col += v3_light_lin3 * 0.2f * STDN pow2( sun );

    // clouds
    vec4 res = raymarch( ro, rd, col );
    col = col * ( 1.0f - res.w ) + res.xyz;
    
    // sun glare
    col += v3_sunglare * 0.2f * STDN pow3( sun );

    ispc_construct( float4 ret, { col.x, col.y, col.z, 1.0f } );
    return ret;
}


// ------------------------------------------------------------------------------------------------

export void renderImageClouds( 
    uniform const int32_t   output_width,
    uniform const int32_t   output_height,
    uniform uint32_t        output[]
    )
{
    uniform float float_width  = (float) output_width;
    uniform float float_height = (float) output_height;
    uniform float recp_width   = 1.0f / float_width;
    uniform float recp_height  = 1.0f / float_height;

    // camera
    ispc_construct( uniform float3 ta,  { 1.0f, -0.6f, 0.0f } );
    ispc_construct( uniform float3 rov, { STDN sin(3.5f), 0.02f, STDN cos(3.5f) } );

    uniform vec3 ro = normalized(rov) * 3.0f;
    uniform float3x3 ca = setCamera( ro, ta, 0.0 );

    tiled_iteration_xy( int, output_width, output_height )
    {
        float dx = ( ( -float_width  ) + (float)(2 * x) ) * recp_height;
        float dy = ( (  float_height ) - (float)(2 * y) ) * recp_height;
        ispc_construct( float2 p, { dx, dy } );

        // ray
        ispc_construct( float3 rayv, { p.x, p.y, 1.5f } );
        vec3 rd = mul( normalized( rayv ), ca );

        vec4 fragColor = saturate( render( ro, rd ) );
        
        uint32_t offset_out = ( y * output_width ) + x;

        output[offset_out] = rgbaFloatToU32( fragColor );
    }
}
