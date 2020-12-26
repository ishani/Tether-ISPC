#pragma once

// support export interfaces that require vector types
#include <swizzle/glsl/naive/vector.h>
using float2 = swizzle::glsl::naive::vector< float, 2 >;

// manually updated by copying signatures from generated _ispc.gen.h files
namespace serial 
{

    void renderImageClouds(
        const int32_t   output_width,
        const int32_t   output_height,
        uint32_t        output[] );

    void renderImageNoiseBall( 
        const uint32_t  output_width, 
        const uint32_t  output_height, 
        uint32_t        output[], 
        const uint32_t  output_pitch );

    void renderImageAmbientOcclusion(
        const int32_t   w,
        const int32_t   h,
        const int32_t   nsubsamples,
        float           image[] );
    void renderImageAmbientOcclusion_ManuallyPorted(
        const int32_t   w,
        const int32_t   h,
        const int32_t   nsubsamples,
        float*          image );

    void polygonsToSDF(
        const float2 vertices[],
        const int32_t polygonSizes[],
        const int32_t polygonCount,
        float sdf_output[],
        int32_t sdf_output_width,
        int32_t sdf_output_height,
        const float world_start_x,
        const float world_start_y,
        const float world_size_x,
        const float world_size_y );

    void synthLoop(
        const int32_t sample_rate,
        const int32_t loop_length,
        const int32_t time_start,
        const int32_t node_length,
        const uint32_t note_data[],
        float sample_left_channel[],
        float sample_right_channel[],
        const uint32_t fx_buffer_length,
        float fx_buffer_left_channel[],
        float fx_buffer_right_channel[] );

    float fft_1024_extract_lowband( float fftDataIn[] );
    void fft_1024_unrolled( float data[] );
}