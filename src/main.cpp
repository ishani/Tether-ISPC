// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// 

#include <cstdlib>
#include <cmath>
#include <cfloat>
#include <cassert>
#include <algorithm>

// ispc & serial function declarations
#include "ispc/rt.exports.h"
#include "ispc/serial.exports.h"

// benchmarking
#define PICOBENCH_IMPLEMENT
#include "picobench/pico.h"


#include "support/utility.h"
#include "support/qlib.fft.h"

// enable or disable specific benchmark runs
#define TETHER_BENCHMARK_SDF
#define TETHER_BENCHMARK_CLOUDS
#define TETHER_BENCHMARK_AO
#define TETHER_BENCHMARK_NOISE
#define TETHER_BENCHMARK_SYNTH
#define TETHER_BENCHMARK_FFT


// ---------------------------------------------------------------------------------------------------------------------

#ifdef TETHER_BENCHMARK_SDF
PICOBENCH_SUITE( "sample-sdf" );

enum sdf
{
    BenchmarkSamples    = 4,
    RenderWidth         = 1920,
    RenderHeight        = 1920
};

#define SDF_POLYDATA(_ty)       \
            _ty{ -0.19f, 3.15f },   \
            _ty{ -0.45f, 3.35f },   \
            _ty{ -0.81f, 3.45f },   \
            _ty{ -1.23f, 3.45f },   \
            _ty{ -1.67f, 3.31f },   \
            _ty{ -2.15f, 3.09f },   \
            _ty{ -2.33f, 2.79f },   \
            _ty{ -2.33f, 2.37f },   \
            _ty{ -2.25f, 2.01f },   \
            _ty{ -2.05f, 1.75f },   \
            _ty{ -1.89f, 1.41f },   \
            _ty{ -2.0f,  1.0f },    \
            _ty{ -2.43f, 0.77f },   \
            _ty{ -2.85f, 0.73f },   \
            _ty{ -3.33f, 0.67f },   \
            _ty{ -3.75f, 0.67f },   \
            _ty{ -4.19f, 0.53f },   \
            _ty{ -4.59f, 0.27f },   \
            _ty{ -4.81f, -0.09f },  \
            _ty{ -4.89f, -0.43f },  \
            _ty{ -5.0f,  -1.0f },   \
            _ty{ -4.93f, -1.35f },  \
            _ty{ -5.13f, -1.65f },  \
            _ty{ -5.37f, -1.97f },  \
            _ty{ -5.49f, -2.55f },  \
            _ty{ -5.49f, -2.99f },  \
            _ty{ -5.21f, -3.51f },  \
            _ty{ -4.79f, -3.75f },  \
            _ty{ -4.25f, -3.95f },  \
            _ty{ -3.79f, -4.01f },  \
            _ty{ -3.17f, -4.01f },  \
            _ty{ -2.61f, -4.01f },  \
            _ty{ -1.59f, -3.49f },  \
            _ty{ -1.0f,  -3.0f },   \
            _ty{ -0.45f, -2.55f },  \
            _ty{ -0.09f, -2.51f },  \
            _ty{ 0.47f,  -2.55f },  \
            _ty{ 1.31f,  -2.85f },  \
            _ty{ 2.0f,   -3.0f },   \
            _ty{ 2.33f,  -3.21f },  \
            _ty{ 2.89f,  -3.23f },  \
            _ty{ 3.41f,  -3.15f },  \
            _ty{ 4.09f,  -2.47f },  \
            _ty{ 4.71f,  -1.47f },  \
            _ty{ 4.83f,  -0.47f },  \
            _ty{ 4.85f,  0.11f },   \
            _ty{ 4.95f,  0.73f },   \
            _ty{ 5.59f,  1.49f },   \
            _ty{ 6.17f,  2.01f },   \
            _ty{ 6.69f,  2.73f },   \
            _ty{ 6.75f,  3.09f },   \
            _ty{ 6.15f,  3.25f },   \
            _ty{ 5.49f,  3.27f },   \
            _ty{ 5.05f,  3.27f },   \
            _ty{ 4.59f,  2.99f },   \
            _ty{ 4.41f,  2.57f },   \
            _ty{ 4.19f,  1.85f },   \
            _ty{ 3.93f,  1.67f },   \
            _ty{ 3.33f,  1.65f },   \
            _ty{ 2.77f,  1.69f },   \
            _ty{ 2.17f,  1.97f },   \
            _ty{ 1.87f,  2.33f },   \
            _ty{ 1.59f,  2.71f },   \
            _ty{ 1.29f,  2.95f },   \
            _ty{ 0.87f,  3.13f },   \
            _ty{ 0.39f,  3.25f },   \
                                    \
            _ty{ -0.74f, -1.1f },   \
            _ty{ -1.3f,  -0.62f },  \
            _ty{ -2.14f, -0.62f },  \
            _ty{ -2.5f,  -1.12f },  \
            _ty{ -2.52f, -1.82f },  \
            _ty{ -2.0f,  -2.0f },   \
            _ty{ -1.22f, -2.1f },   \
            _ty{ -0.76f, -1.58f }, 


// stub function that takes the actual call to execute for profiling; one sample run will write out the result as a PNG
template < typename _float2type, typename _dispatch >
inline void indirectRenderSDF( picobench::state& s, const char* hostFunctionName, const _float2type c_vertices, const _dispatch& dispatch )
{
    const uint32_t polysWalked = (uint32_t)s.iterations();

    alignas(16) const std::array<int32_t, 2> c_poly { 66, 8 };

    container::AlignedFloatBuffer floatBuffer( sdf::RenderWidth * sdf::RenderHeight, 0.0f );
    {
        picobench::scope scope( s );
        dispatch( c_vertices.data(), c_poly.data(), polysWalked, floatBuffer.data(), sdf::RenderWidth, sdf::RenderHeight, -8.0f, -8.0f, 16.0f, 16.0f );
    }

    if ( s.sampleIndex() == 0 )
    {
        container::ImageBuffer imageOut( sdf::RenderWidth, sdf::RenderHeight );

        ispc::SDFToRGB( floatBuffer.data(), sdf::RenderWidth, sdf::RenderHeight, imageOut.data(), sdf::RenderWidth, 1.0f / 10.0f );

        imageOut.saveToPNG( hostFunctionName, polysWalked );
    }
}

// ISPC variant
static void sample_sdf_ispc( picobench::state& s )
{
    printf( "=" );

    alignas(16) const std::array< ispc::float2, 74 > c_vertices { SDF_POLYDATA(ispc::float2) };

    indirectRenderSDF( s, __FUNCTION__, c_vertices, ispc::polygonsToSDF );
}
PICOBENCH( sample_sdf_ispc )
        .label( "ispc" )
        .samples( sdf::BenchmarkSamples )
        .iterations( {1, 2} );


// auto-serial variant
static void sample_sdf_serial( picobench::state& s )
{
    printf( "-" );

    alignas(16) const std::array< float2, 74 > c_vertices { SDF_POLYDATA( float2 ) };

    indirectRenderSDF( s, __FUNCTION__, c_vertices, serial::polygonsToSDF );
}
PICOBENCH( sample_sdf_serial )
        .label( "serial" )
        .samples( sdf::BenchmarkSamples )
        .iterations( {1, 2} );

#endif // TETHER_BENCHMARK_SDF


// ---------------------------------------------------------------------------------------------------------------------

#ifdef TETHER_BENCHMARK_CLOUDS
PICOBENCH_SUITE( "sample-render-clouds" );
namespace sample_render_clouds {

enum constants
{
    BenchmarkSamples = 4,
};
static const std::vector<int> benchmark_iterations{ 320, 640 }; // width of images to render out


// stub function that takes the actual call to execute for profiling; one sample run will write out the result as a PNG
template < typename _dispatch >
inline void executeIndirect( picobench::state& s, const char* hostFunctionName, const _dispatch& dispatch )
{
    uint32_t renderWidth  = (uint32_t)s.iterations();
    uint32_t renderHeight = (uint32_t)s.iterations() / 2;

    container::ImageBuffer imageOut( renderWidth, renderHeight );
    {
        picobench::scope scope( s );
        dispatch( renderWidth, renderHeight, imageOut.data() );
    }

    if ( s.sampleIndex() == 0 )
    {
        imageOut.saveToPNG( hostFunctionName, renderWidth );
    }
}

} // namespace sample_render_clouds

// ISPC variant
static void sample_clouds_ispc( picobench::state& s )
{
    printf( "=" );
    sample_render_clouds::executeIndirect( s, __FUNCTION__, ispc::renderImageClouds );
}
PICOBENCH( sample_clouds_ispc )
        .label( "ispc" )
        .samples( sample_render_clouds::constants::BenchmarkSamples )
        .iterations( sample_render_clouds::benchmark_iterations );

// auto-serial variant
static void sample_clouds_serial( picobench::state& s )
{
    printf( "-" );
    sample_render_clouds::executeIndirect( s, __FUNCTION__, serial::renderImageClouds );
}
PICOBENCH( sample_clouds_serial )
        .label( "serial" )
        .samples( sample_render_clouds::constants::BenchmarkSamples )
        .iterations( sample_render_clouds::benchmark_iterations );

#endif // TETHER_BENCHMARK_AO


// ---------------------------------------------------------------------------------------------------------------------

#ifdef TETHER_BENCHMARK_AO
PICOBENCH_SUITE( "sample-render-ao" );
namespace sample_render_ao {

enum constants
{
    BenchmarkSamples = 4,
    RenderWidth = 600,
    RenderHeight = 320
};
static const std::vector<int> benchmark_iterations{ 1, 2, 4, 8 }; // range of subsample values to run across benchmarks


// stub function that takes the actual call to execute for profiling; one sample run will write out the result as a PNG
template < typename _dispatch >
inline void executeIndirect( picobench::state& s, const char* hostFunctionName, const _dispatch& dispatch )
{
    const uint32_t aoSubSamples = (uint32_t)s.iterations();

    container::AlignedFloatBuffer floatBuffer( constants::RenderWidth * constants::RenderHeight, 0.0f );
    {
        picobench::scope scope( s );
        dispatch( constants::RenderWidth, constants::RenderHeight, aoSubSamples, floatBuffer.data() );
    }

    if ( s.sampleIndex() == 0 )
    {
        container::ImageBuffer imageOut( constants::RenderWidth, constants::RenderHeight );

        ispc::float1ToRGB( floatBuffer.data(), constants::RenderWidth, constants::RenderHeight, imageOut.data(), constants::RenderWidth );

        imageOut.saveToPNG( hostFunctionName, aoSubSamples );
    }
}

} // namespace sample_render_ao

// ISPC variant
static void sample_aobench_ispc( picobench::state& s )
{
    printf( "=" );
    sample_render_ao::executeIndirect( s, __FUNCTION__, ispc::renderImageAmbientOcclusion );
}
PICOBENCH( sample_aobench_ispc )
        .label( "ispc" )
        .samples( sample_render_ao::constants::BenchmarkSamples )
        .iterations( sample_render_ao::benchmark_iterations );

// auto-serial variant
static void sample_aobench_serial( picobench::state& s )
{
    printf( "-" );
    sample_render_ao::executeIndirect( s, __FUNCTION__, serial::renderImageAmbientOcclusion );
}
PICOBENCH( sample_aobench_serial )
        .label( "serial" )
        .samples( sample_render_ao::constants::BenchmarkSamples )
        .iterations( sample_render_ao::benchmark_iterations );

// manually ported serial variant
static void sample_aobench_serial_manual( picobench::state& s )
{
    printf( "-" );
    sample_render_ao::executeIndirect( s, __FUNCTION__, serial::renderImageAmbientOcclusion_ManuallyPorted );
}
PICOBENCH( sample_aobench_serial_manual )
        .label( "serial_manual" )
        .samples( sample_render_ao::constants::BenchmarkSamples )
        .iterations( sample_render_ao::benchmark_iterations );

#endif // TETHER_BENCHMARK_AO


// ---------------------------------------------------------------------------------------------------------------------

#ifdef TETHER_BENCHMARK_NOISE
PICOBENCH_SUITE( "sample-render-noise" );
namespace sample_render_noise {

enum constants
{
    BenchmarkSamples = 2,
};
static const std::vector<int> benchmark_iterations{ 720, 1920 }; // output resolutions


// stub function that takes the actual call to execute for profiling; one sample run will write out the result as a PNG
template < typename _dispatch >
inline void executeIndirect( picobench::state& s, const char* hostFunctionName, const _dispatch& dispatch )
{
    const uint32_t renderWidth = (uint32_t)s.iterations();
    const uint32_t renderHeight = (uint32_t)((float)s.iterations() * 0.5625f);

    container::ImageBuffer imageOut( renderWidth, renderHeight );
    {
        picobench::scope scope( s );
        dispatch( renderWidth, renderHeight, imageOut.data(), renderWidth );
    }

    if ( s.sampleIndex() == 0 )
    {
        imageOut.saveToPNG( hostFunctionName, renderWidth );
    }
}

} // namespace sample_render_noise

// ISPC variant
static void sample_noise_ispc( picobench::state& s )
{
    printf( "=" );
    sample_render_noise::executeIndirect( s, __FUNCTION__, ispc::renderImageNoiseBall );
}
PICOBENCH( sample_noise_ispc )
        .label( "ispc" )
        .samples( sample_render_noise::constants::BenchmarkSamples )
        .iterations( sample_render_noise::benchmark_iterations );

// auto-serial variant
static void sample_noise_serial( picobench::state& s )
{
    printf( "-" );
    sample_render_noise::executeIndirect( s, __FUNCTION__, serial::renderImageNoiseBall );
}
PICOBENCH( sample_noise_serial )
        .label( "serial" )
        .samples( sample_render_noise::constants::BenchmarkSamples )
        .iterations( sample_render_noise::benchmark_iterations );

#endif // TETHER_BENCHMARK_NOISE

// ---------------------------------------------------------------------------------------------------------------------

#ifdef TETHER_BENCHMARK_SYNTH
PICOBENCH_SUITE( "sample-synth" );
namespace sample_synth {

enum constants
{
    BenchmarkSamples        = 4,
    SampleRate              = 48000,
    FXBufferMaskableLength  = 0xFFFF,
};
static const std::vector<int> benchmark_iterations{ 1, 10, 30 }; // length of audio clips to generate

// stub function that takes the actual call to execute for profiling; one sample run will write out the result as a PNG
template < typename _dispatch >
inline void executeIndirect( picobench::state& s, const char* hostFunctionName, const _dispatch& dispatch )
{
    const uint32_t synthOutputLength = (uint32_t)s.iterations();

    // delay FX buffers
    container::AlignedFloatBuffer fxBufferLeft(  constants::FXBufferMaskableLength, 0.0f );
    container::AlignedFloatBuffer fxBufferRight( constants::FXBufferMaskableLength, 0.0f );

    static constexpr size_t noteDataLength = 6;
    alignas(16) const std::array<uint32_t, noteDataLength> noteData { 3, 5, 2, 7, 5, 8 }; // Note_# from common.audio.inl.isph

    container::WaveData< container::WaveChannels::Stereo, constants::SampleRate > waveData( synthOutputLength );
    {
        picobench::scope scope( s );

        dispatch( 
            constants::SampleRate,
            synthOutputLength,
            0,
            noteDataLength,
            noteData.data(),
            waveData.sampleChannel( 0 ),
            waveData.sampleChannel( 1 ),
            constants::FXBufferMaskableLength,
            fxBufferLeft.data(),
            fxBufferRight.data() );
    }

    if ( s.sampleIndex() == 0 )
    {
        waveData.saveToWAV( hostFunctionName, synthOutputLength );
    }
}
} // namespace sample_synth

// ISPC variant
static void sample_synth_ispc( picobench::state& s )
{
    printf( "=" );
    sample_synth::executeIndirect( s, __FUNCTION__, ispc::synthLoop );
}
PICOBENCH( sample_synth_ispc )
        .label( "ispc" )
        .samples( sample_synth::constants::BenchmarkSamples )
        .iterations( sample_synth::benchmark_iterations );

// auto-serial variant
static void sample_synth_serial( picobench::state& s )
{
    printf( "-" );
    sample_synth::executeIndirect( s, __FUNCTION__, serial::synthLoop );
}
PICOBENCH( sample_synth_serial )
        .label( "serial" )
        .samples( sample_synth::constants::BenchmarkSamples )
        .iterations( sample_synth::benchmark_iterations );

#endif // TETHER_BENCHMARK_SYNTH


// ---------------------------------------------------------------------------------------------------------------------

#ifdef TETHER_BENCHMARK_FFT
PICOBENCH_SUITE( "sample-fft" );
namespace sample_fft {

enum constants
{
    BenchmarkSamples        = 4
};
static const std::vector<int> benchmark_iterations{ 64, 6000, 12000, 24000 };

void populateBuffer( container::AlignedFloatBuffer& buffer )
{
    float* fftBufferData = buffer.data();
    for ( uint32_t i = 0; i < buffer.numElements(); i += 2 )
    {
        fftBufferData[i] = std::sin( (float)i * 0.1f ) + 
                           std::cos( (float)i * 0.001f ) + 
                           std::sin( (float)i * 3.14f );
        fftBufferData[i + 1] = 0;
    }
}

} // namespace sample_fft

// ISPC variant
static void sample_fft_ispc( picobench::state& s )
{
    printf( "=" );

    const uint32_t fftBlocks = (uint32_t)s.iterations();

    container::AlignedFloatBuffer fftBand0( fftBlocks, 0.0f );

    container::AlignedFloatBuffer fftBuffer( fftBlocks * 2048, 0.0f );
    sample_fft::populateBuffer( fftBuffer );
    {
        picobench::scope scope( s );
        for ( uint32_t f = 0; f < fftBlocks; f++ )
        {
            float* dataBlock = fftBuffer.data() + (f * 2048);
            ispc::fft_1024_unrolled( dataBlock );
            fftBand0.data()[f] = ispc::fft_1024_extract_lowband( dataBlock );
        }
    }

    container::AlignedFloatBuffer fftCheck( fftBlocks * 2048, 0.0f );
    sample_fft::populateBuffer( fftCheck );
    {
        for ( uint32_t f = 0; f < fftBlocks; f++ )
        {
            float* dataBlock = fftCheck.data() + (f * 2048);
            dsp::fft<1024>( dataBlock );
            float subband0 = serial::fft_1024_extract_lowband( dataBlock );

            const float diff = std::abs( fftBand0.data()[f] - subband0 );
            if ( diff > 0.001f )
            {
                printf( "\nISPC/C++ FFT lowband diverged at %u => [%.24f] vs [%.24f]\n", f, subband0, fftBand0.data()[f] );
            }
        }
    }

    // check we are getting broadly the same results, catching any major screw up in ISPC version
    // there will be small variants due to math library results / precision differences
    for ( uint32_t f = 0; f < fftBuffer.numElements(); f++ )
    {
        const float diff = std::abs( fftBuffer.data()[f] - fftCheck.data()[f] );
        if ( diff > 0.001f )
        {
            printf( "\nISPC/C++ FFT diverged at %u => [%.24f] vs [%.24f]\n", f, fftBuffer.data()[f], fftCheck.data()[f] );
        }
    }
}
PICOBENCH( sample_fft_ispc )
        .label( "ispc" )
        .samples( sample_fft::constants::BenchmarkSamples )
        .iterations( sample_fft::benchmark_iterations );

// auto-serial variant
static void sample_fft_serial( picobench::state& s )
{
    printf( "-" );

    const uint32_t fftBlocks = (uint32_t)s.iterations();

    container::AlignedFloatBuffer fftBand0( fftBlocks, 0.0f );

    container::AlignedFloatBuffer fftBuffer( fftBlocks * 2048, 0.0f );
    sample_fft::populateBuffer( fftBuffer );
    {
        picobench::scope scope( s );
        for ( uint32_t f = 0; f < fftBlocks; f++ )
        {
            float* dataBlock = fftBuffer.data() + (f * 2048);
            serial::fft_1024_unrolled( dataBlock );
            fftBand0.data()[f] = serial::fft_1024_extract_lowband( dataBlock );
        }
    }
}
PICOBENCH( sample_fft_serial )
        .label( "serial" )
        .samples( sample_fft::constants::BenchmarkSamples )
        .iterations( sample_fft::benchmark_iterations );

// qlib serial variant
static void sample_fft_serial_qlib( picobench::state& s )
{
    printf( "-" );

    const uint32_t fftBlocks = (uint32_t)s.iterations();

    container::AlignedFloatBuffer fftBand0( fftBlocks, 0.0f );

    container::AlignedFloatBuffer fftBuffer( fftBlocks * 2048, 0.0f );
    sample_fft::populateBuffer( fftBuffer );
    {
        picobench::scope scope( s );
        for ( size_t f = 0; f < fftBlocks; f++ )
        {
            float* dataBlock = fftBuffer.data() + (f * 2048);
            dsp::fft<1024>( dataBlock );
            fftBand0.data()[f] = serial::fft_1024_extract_lowband( dataBlock );
        }
    }
}
PICOBENCH( sample_fft_serial_qlib )
        .label( "serial_qlib" )
        .samples( sample_fft::constants::BenchmarkSamples )
        .iterations( sample_fft::benchmark_iterations );

#endif // TETHER_BENCHMARK_FFT


// ---------------------------------------------------------------------------------------------------------------------

int main( int argc, char** argv )
{
    printf( "Tether-ISPC\n" );
    printf( "ishani.org 2020\n" );

    printf( "--------------------------------------------\n" );
    printf( "Running benchmarks, this may take a while...\n\n" );

    picobench::runner benchmarking;
    benchmarking.parse_cmd_line( argc, argv );

    return benchmarking.run();
}