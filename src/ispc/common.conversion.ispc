// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// 
//

#include "common.isph"


// ------------------------------------------------------------------------------------------------
// convert a single channel float data buffer to a RGB 32-bit output image (greyscale)

export void float1ToRGB( 
    uniform float       input[],
    uniform uint32_t    input_width,
    uniform uint32_t    input_height,
    uniform uint32_t    output[],
    uniform uint32_t    output_pitch
    )
{
    tiled_iteration_xy( uint32_t, input_width, input_height )
    {
        const uint32_t offset_in = ( y * input_width ) + x;

        #pragma ignore warning(perf)
        const float iv = saturate( input[offset_in] );

        const float3 rgbF = { iv, iv, iv };

        const uint32_t offset_out = ( y * output_pitch ) + x;

        #pragma ignore warning(perf)
        output[offset_out] = rgbFloatToU32( rgbF );
    }
}

// ---------------------------------------------------------------------------------------------------------------------
// 
float3 gradient_rainbow( const float  t )
{
    ispc_construct( const float2 cs1, _ctf2 { cos( 1.0f * t * 6.283185307179586f ), sin( 1.0f * t * 6.283185307179586f ) } );
    ispc_construct( const float2 cs2, _ctf2 { cos( 2.0f * t * 6.283185307179586f ), sin( 2.0f * t * 6.283185307179586f ) } );


    ispc_construct( static uniform const float3 v0, _ctf3 {  0.4499723076135584f,  0.609426607533859f,   0.4288887656855271f   } );
    ispc_construct( static uniform const float3 v1, _ctf3 {  1.356958715978088f,  -0.6223492834243289f, -0.2455749072607498f   } );
    ispc_construct( static uniform const float3 v2, _ctf3 { -0.2058207830435541f,  0.4820199928163624f, -0.8671833275731918f   } );
    ispc_construct( static uniform const float3 v3, _ctf3 { -0.2862391770341579f,  0.05434355975084173f, 0.4356605836093163f   } );
    ispc_construct( static uniform const float3 v4, _ctf3 { -0.5279746052180661f, -0.1719661920391326f, -0.2836479508431202f   } );


    ispc_construct( static uniform const float3 r0, _ctf3 {  1.0f,                 1.0f,                 1.0f                  } );
    ispc_construct( static uniform const float3 r1, _ctf3 {  0.7153502777378531f, -0.9219020024148035f, -0.2910109117528888f   } );
    ispc_construct( static uniform const float3 r2, _ctf3 { -0.3381133734426577f,  0.7903005432576772f, -0.3172368432843283f   } );
    ispc_construct( static uniform const float3 r3, _ctf3 { -0.2639897520454177f,  0.06346650999193199f, 0.5784878335459051f   } );
    ispc_construct( static uniform const float3 r4, _ctf3 { -0.3066564712099898f, -0.2161956627263612f, -0.2188031991633754f   } );

    float3 n = v0 + ( v1 * cs1.x ) + 
                    ( v2 * cs1.y ) + 
                    ( v3 * cs2.x ) + 
                    ( v4 * cs2.y );
    float3 d = r0 + ( r1 * cs1.x ) + 
                    ( r2 * cs1.y ) + 
                    ( r3 * cs2.x ) + 
                    ( r4 * cs2.y );

    return n/d;
}

uint32 gradient_rainbow_u32( const float  t )
{
    return rgbFloatToU32( gradient_rainbow( frac(t) ) );
}


// ------------------------------------------------------------------------------------------------
// turn a distance field into an RGB image with rainbow gradient on distances between 0 .. 1/distanceScale

export void SDFToRGB( 
    uniform float       input[],
    uniform uint32_t    input_width,
    uniform uint32_t    input_height,
    uniform uint32_t    output[],
    uniform uint32_t    output_pitch,
    uniform float       distanceScale
    )
{
    uniform float recp_width  = 1.0f / input_width;
    uniform float recp_height = 1.0f / input_height;

    tiled_iteration_xy( uint32_t, input_width, input_height )
    {
        const uint32_t offset_in = ( y * input_width ) + x;

        #pragma ignore warning(perf)
        const float iv = input[offset_in] * distanceScale;

        const uint32_t rgbU32   = gradient_rainbow_u32( iv * 2.0 );

        const uint32_t offset_out = ( y * output_pitch ) + x;

        #pragma ignore warning(perf)
        output[offset_out] = rgbU32;
    }
}

