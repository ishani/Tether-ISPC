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

        const float3   rgbF     = cosineGradientRainbow( iv );
        const uint32_t rgbU32   = rgbFloatToU32( rgbF );

        const uint32_t offset_out = ( y * output_pitch ) + x;

        #pragma ignore warning(perf)
        output[offset_out] = rgbU32;
    }
}

