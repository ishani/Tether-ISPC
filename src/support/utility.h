// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// some common bits
//

#pragma once

#include <cstdlib>
#include <cmath>
#include <cfloat>
#include <memory>
#include <vector>
#include <string>
#include <string.h>

// image export
#include "stb/stb_image_write.h"

// pull in __rdtsc()
#ifdef WIN32
#include <intrin.h>
inline uint64_t _u64_rand() { return __rdtsc(); }
#else
#include <sys/time.h>
#include <time.h>
inline uint64_t _u64_rand() 
{
    struct timeval tv;
    gettimeofday( &tv, nullptr );
    return (uint64_t)( static_cast<int64_t>(tv.tv_sec) * 1000000 + tv.tv_usec );
}
#endif

// ---------------------------------------------------------------------------------------------------------------------
namespace utils
{
    // allocate numElements of _T aligned to 16 bytes
    template< typename _T >
    inline static _T* allocateAlign16( const size_t numElements )
    {
#ifdef WIN32
        return reinterpret_cast<_T*>(_aligned_malloc( sizeof( _T ) * numElements, 16 ));
#else
        return reinterpret_cast<_T*>(aligned_alloc( 16, sizeof( _T ) * numElements ));
#endif
    }

    // free memory allocated with allocateAlign16
    inline static void freeAlign16( void* ptr )
    {
#ifdef WIN32
        return _aligned_free( ptr );
#else
        return free( ptr );
#endif
    }

    // mix a RDTSC value to produce a random seed
    inline static uint64_t randomU64()
    {
        uint64_t value = _u64_rand();
        value ^= value >> 33;
        value *= 0x64dd81482cbd31d7UL;
        value ^= value >> 33;
        value *= 0xe36aa5c613612997UL;
        value ^= value >> 33;

        return value;
    }

    // https://stackoverflow.com/questions/2342162/stdstring-formatting-like-sprintf
    template<typename ... Args>
    std::string stringFormat( const char* format, Args ... args )
    {
        size_t size = snprintf( nullptr, 0, format, args ... ) + 1; // Extra space for '\0'
        if ( size <= 0 )
            return "";

        std::unique_ptr<char[]> buf( new char[size] );
        snprintf( buf.get(), size, format, args ... );
        return std::string( buf.get(), buf.get() + size - 1 ); // We don't want the '\0' inside
    }

} // namespace utils

#ifdef DEBUG
inline uint64_t _memory_rand_offset() { return 0; }
#else
inline uint64_t _memory_rand_offset() { return 16 * (utils::randomU64() & 0xFFFFF); }
#endif // _DEBUG

// ---------------------------------------------------------------------------------------------------------------------
namespace container
{
    // simple 1D float buffer, aligned on 16b
    struct AlignedFloatBuffer
    {
        AlignedFloatBuffer() = delete;
        AlignedFloatBuffer( const AlignedFloatBuffer& ) = delete;

        inline AlignedFloatBuffer( const uint32_t _elements, const float initialValue )
            : m_elements( _elements )
        {
            uint64_t randomExtraInset = _memory_rand_offset();

            m_memory = utils::allocateAlign16<float>( m_elements + randomExtraInset );
            m_data = m_memory + randomExtraInset;

            for ( uint32_t i = 0; i < m_elements; i++ )
                m_memory[i] = initialValue;
        }

        inline ~AlignedFloatBuffer()
        {
            utils::freeAlign16( m_memory );
            m_memory = m_data = nullptr;
        }

        inline float* data() { return m_data; }
        inline uint32_t numElements() const { return m_elements; }

    private:
        uint32_t    m_elements;
        float* m_data;     // usable data start, potentially inset from m_memory
        float* m_memory;   // original allocation
    };

    // -----------------------------------------------------------------------------------------------------------------
    // quick wrapper around an aligned RGBA image buffer that can be quickly saved to PNG via STB
    struct ImageBuffer
    {
        ImageBuffer() = delete;
        ImageBuffer( const ImageBuffer& ) = delete;

        inline ImageBuffer( const uint32_t _width, const uint32_t _height )
            : m_width( _width )
            , m_height( _height )
        {
            uint64_t randomExtraInset = _memory_rand_offset();

            m_memory = utils::allocateAlign16<uint32_t>( (m_width * m_height) + randomExtraInset );
            m_data = m_memory + randomExtraInset;

            memset( m_data, 0, sizeof( uint32_t ) * m_width * m_height );
        }

        inline ~ImageBuffer()
        {
            utils::freeAlign16( m_memory );
            m_memory = m_data = nullptr;
        }

        inline void saveToPNG( const char* nametag, const uint32_t iteration ) const
        {
            const std::string pngPath = utils::stringFormat( "%s_[%02u]_%ux%u.png", nametag, iteration, m_width, m_height );

            int32_t writeError = stbi_write_png( pngPath.c_str(), m_width, m_height, 4, m_data, sizeof( uint32_t ) * m_width );
            if ( !writeError )
                printf( "\nFailed to write [%s] - STB error code %i\n", pngPath.c_str(), writeError );
        }

        inline uint32_t  width()    const { return m_width; }
        inline uint32_t  height()   const { return m_width; }
        inline uint32_t* data()           { return m_data; }

    private:
        uint32_t    m_width;
        uint32_t    m_height;
        uint32_t*   m_data;     // image data start, potentially inset from m_memory
        uint32_t*   m_memory;   // original allocation
    };



    enum WaveChannels
    {
        Mono = 1,
        Stereo = 2
    };

    // -----------------------------------------------------------------------------------------------------------------
    // a helper container that provides a buffer to write audio samples into that can be written to an uncompressed WAV on disk
    template < WaveChannels _channels, uint32_t _sampleRate >
    class WaveData
    {
        static constexpr double     c_timePerSample     = 1.0 / (double)_sampleRate;    // seconds represented by a single sample
        static constexpr uint32_t   c_bytesPerSample    = sizeof( uint32_t );
        static constexpr uint32_t   c_bitsPerSample     = c_bytesPerSample * 8;

    public:

        WaveData( uint32_t secondsOfAudio )
            : m_lengthInSeconds( secondsOfAudio )
        {
            m_sourceAudioNumSamplesPerChannel = _sampleRate * secondsOfAudio;

            for ( uint32_t chan = 0; chan < _channels; chan++ )
            {
                float* audioData = utils::allocateAlign16<float>( m_sourceAudioNumSamplesPerChannel );
                m_sourceAudioChannels.emplace_back( audioData );
            }
        }

        ~WaveData()
        {
            for ( float* data : m_sourceAudioChannels )
                utils::freeAlign16( data );
            m_sourceAudioChannels.clear();
        }

        inline static constexpr float clamp( const float v, const float lo, const float hi )
        {
            return (v < lo) ? lo : (hi < v) ? hi : v;
        }

        inline bool saveToWAV( const char* nametag, const uint32_t iteration ) const
        {
            const std::string wavPath = utils::stringFormat( "%s_[%02u sec]_%u_%ic.wav", nametag, iteration, _sampleRate, _channels );

#ifdef WIN32
            FILE* pfile = nullptr;
            fopen_s( &pfile, wavPath.c_str(), "w+b" );
#else
            FILE* pfile = fopen( wavPath.c_str(), "w+b" );
#endif
            if ( !pfile )
            {
                printf( "\nFailed to write [%s] - cannot open file for writing\n", wavPath.c_str() );
                return false;
            }

            WaveFileHeader waveHeader( m_sourceAudioNumSamplesPerChannel * _channels );
            fwrite( &waveHeader, sizeof( WaveFileHeader ), 1, pfile );

            // convert and write (interleaved) samples; yeah, not very efficient fwrite'ing one at a time but
            for ( auto sampleIndex = 0U; sampleIndex < sampleCount(); sampleIndex++ )
            {
                for ( const float* sampleData : sampleChannels() )
                {
                    const float clampedSampleF = clamp( sampleData[sampleIndex], -1.0f, 1.0f );

                    const auto sampleI32 = (int32_t)( (double)clampedSampleF * (double)INT32_MAX );

                    fwrite( &sampleI32, sizeof( int32_t ), 1, pfile );
                }
            }

            fclose( pfile );
            return true;
        }

        inline double                       timeDeltaPerSample()  const { return c_timePerSample; }
        inline uint32_t                     sampleCount()         const { return m_sourceAudioNumSamplesPerChannel; }
        inline const std::vector<float*>&   sampleChannels()      const { return m_sourceAudioChannels; }
        inline float* sampleChannel( size_t idx )                       { return m_sourceAudioChannels[idx]; }

    private:

        uint32_t                m_lengthInSeconds;
        uint32_t                m_sourceAudioNumSamplesPerChannel;
        std::vector<float*>     m_sourceAudioChannels;

        struct WaveFileHeader
        {
    #define	FOURCC(a, b, c, d)     ((uint32_t) ((a) | ((b) << 8) | ((c) << 16) | (((uint32_t) (d)) << 24)))

            WaveFileHeader( uint32_t totalSampleCount )
            {
                m_chunkID       = FOURCC( 'R', 'I', 'F', 'F' );
                m_format        = FOURCC( 'W', 'A', 'V', 'E' );

                m_subChunk1ID   = FOURCC( 'f', 'm', 't', ' ' );
                m_subChunk1Size = 16;
                m_audioFormat   = 1;
                m_numChannels   = (uint16_t)_channels;
                m_sampleRate    = _sampleRate;
                m_byteRate      = m_sampleRate * m_numChannels * c_bytesPerSample;
                m_blockAlign    = m_numChannels * c_bytesPerSample;
                m_bitsPerSample = c_bitsPerSample;

                m_subChunk2ID   = FOURCC( 'd', 'a', 't', 'a' );
                m_subChunk2Size = totalSampleCount * c_bytesPerSample;
            }

    #undef FOURCC

            // the main chunk
            uint32_t      m_chunkID;
            uint32_t      m_chunkSize;
            uint32_t      m_format;

            // sub chunk 1 "fmt "
            uint32_t      m_subChunk1ID;
            uint32_t      m_subChunk1Size;
            uint16_t      m_audioFormat;
            uint16_t      m_numChannels;
            uint32_t      m_sampleRate;
            uint32_t      m_byteRate;
            uint16_t      m_blockAlign;
            uint16_t      m_bitsPerSample;

            // sub chunk 2 "data"
            uint32_t      m_subChunk2ID;
            uint32_t      m_subChunk2Size;
        };
    };

} // namespace container

