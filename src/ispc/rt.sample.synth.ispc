// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// create some simple (stateless) oscillation synth audio data with a post-process one-tap delay effect
// 

#include "common.isph"

// ---------------------------------------------------------------------------------------------------------------------
// precomputed table of pitch frequencies for a key @ octave
ispc_construct( static uniform const float c_key_frequencies_by_octave[], {
    27.50000000f,   // A  0
    29.13523509f,   // As 0
    30.86770633f,   // B  0
    16.35159783f,   // C  0
    17.32391444f,   // Cs 0
    18.35404799f,   // D  0
    19.44543648f,   // Ds 0
    20.60172231f,   // E  0
    21.82676446f,   // F  0
    23.12465142f,   // Fs 0
    24.49971475f,   // G  0
    25.95654360f,   // Gs 0
    55.00000000f,   // A  1
    58.27047019f,   // As 1
    61.73541266f,   // B  1
    32.70319566f,   // C  1
    34.64782887f,   // Cs 1
    36.70809599f,   // D  1
    38.89087297f,   // Ds 1
    41.20344461f,   // E  1
    43.65352893f,   // F  1
    46.24930284f,   // Fs 1
    48.99942950f,   // G  1
    51.91308720f,   // Gs 1
    110.00000000f,  // A  2
    116.54094038f,  // As 2
    123.47082531f,  // B  2
    65.40639133f,   // C  2
    69.29565774f,   // Cs 2
    73.41619198f,   // D  2
    77.78174593f,   // Ds 2
    82.40688923f,   // E  2
    87.30705786f,   // F  2
    92.49860568f,   // Fs 2
    97.99885900f,   // G  2
    103.82617439f,  // Gs 2
    220.00000000f,  // A  3
    233.08188076f,  // As 3
    246.94165063f,  // B  3
    130.81278265f,  // C  3
    138.59131549f,  // Cs 3
    146.83238396f,  // D  3
    155.56349186f,  // Ds 3
    164.81377846f,  // E  3
    174.61411572f,  // F  3
    184.99721136f,  // Fs 3
    195.99771799f,  // G  3
    207.65234879f,  // Gs 3
    440.00000000f,  // A  4
    466.16376152f,  // As 4
    493.88330126f,  // B  4
    261.62556530f,  // C  4
    277.18263098f,  // Cs 4
    293.66476792f,  // D  4
    311.12698372f,  // Ds 4
    329.62755691f,  // E  4
    349.22823143f,  // F  4
    369.99442271f,  // Fs 4
    391.99543598f,  // G  4
    415.30469758f,  // Gs 4
    880.00000000f,  // A  5
    932.32752304f,  // As 5
    987.76660251f,  // B  5
    523.25113060f,  // C  5
    554.36526195f,  // Cs 5
    587.32953583f,  // D  5
    622.25396744f,  // Ds 5
    659.25511383f,  // E  5
    698.45646287f,  // F  5
    739.98884542f,  // Fs 5
    783.99087196f,  // G  5
    830.60939516f,  // Gs 5
    1760.00000000f, // A  6
    1864.65504607f, // As 6
    1975.53320502f, // B  6
    1046.50226120f, // C  6
    1108.73052391f, // Cs 6
    1174.65907167f, // D  6
    1244.50793489f, // Ds 6
    1318.51022765f, // E  6
    1396.91292573f, // F  6
    1479.97769085f, // Fs 6
    1567.98174393f, // G  6
    1661.21879032f, // Gs 6
    3520.00000000f, // A  7
    3729.31009214f, // As 7
    3951.06641005f, // B  7
    2093.00452240f, // C  7
    2217.46104781f, // Cs 7
    2349.31814334f, // D  7
    2489.01586978f, // Ds 7
    2637.02045530f, // E  7
    2793.82585146f, // F  7
    2959.95538169f, // Fs 7
    3135.96348785f, // G  7
    3322.43758064f, // Gs 7
    7040.00000000f, // A  8
    7458.62018429f, // As 8
    7902.13282010f, // B  8
    4186.00904481f, // C  8
    4434.92209563f, // Cs 8
    4698.63628668f, // D  8
    4978.03173955f, // Ds 8
    5274.04091061f, // E  8
    5587.65170293f, // F  8
    5919.91076339f, // Fs 8
    6271.92697571f, // G  8
    6644.87516128f, // Gs 8
});

float frequencyForNote( const Note eNote, const int octave )
{
    return c_key_frequencies_by_octave[ (octave * 12) + eNote ];
}

// ---------------------------------------------------------------------------------------------------------------------
// create some wobbly synth noise
export void synthLoop( 
    uniform const int    sample_rate,
    uniform const int    loop_length,
    uniform const int    time_start,
    uniform const int    node_length,
    uniform const uint   note_data[],
    uniform float        sample_left_channel[],
    uniform float        sample_right_channel[],
    uniform const uint   fx_buffer_length_maskable,
    uniform float        fx_buffer_left_channel[],
    uniform float        fx_buffer_right_channel[]
    )
{
    uniform const int totalSamples      = loop_length * sample_rate;
    uniform const float deltaTime       = 1.0f / sample_rate;
    uniform const float startTime       = (float)time_start; // seconds

    // handful of fixed-time ADSR envelopes to boop stuff about with
    ispc_construct( uniform const ConfigADSR env1, { 0.1f,  0.5f, 0.2f,  0.2f, 0.4f } );
    ispc_construct( uniform const ConfigADSR env2, { 0.6f,  0.1f, 0.1f,  0.1f, 0.6f } );
    ispc_construct( uniform const ConfigADSR env3, { 0.7f,  0.2f, 0.01f, 0.1f, 0.2f } );
    ispc_construct( uniform const ConfigADSR env4, { 0.05f, 0.5f, 0.2f,  0.1f, 0.3f } );

    // generation is stateless so we can use foreach in ISPC mode and produce samples as wide as we're running
#ifdef TETHER_COMPILE_SERIAL
    for (uniform int sampleIndex = 0; sampleIndex < totalSamples; sampleIndex ++)
#else
    foreach (sampleIndex = 0 ... totalSamples)
#endif
    {
        const float currentTime  = startTime + ( deltaTime * (float)sampleIndex );

        const float nodeTime     = currentTime * 4.0f;
        ispc_construct( float2 timeVec, { currentTime, nodeTime } );
        timeVec = frac(timeVec);

        const float noteMix      = timeVec.y;
        const float noteMixS1    = smoothstep( 0.0f, 0.6f, noteMix );
        const float noteMixS2    = smoothstep( 0.6f, 1.0f, noteMix );

        const int note_index     = ( (int)nodeTime ) % node_length;
        const int note_index_nx  = ( note_index + 1 ) % node_length;
        const Note note_value    = (Note)note_data[ note_index ];
        const Note note_value_nx = (Note)note_data[ note_index_nx ];


        const float slowTime     = currentTime * 0.025f;
        const float quarterTime  = currentTime * 0.25f;
        const float halfTime     = currentTime * 0.5f;

        ispc_construct( float4 sequences, { halfTime, quarterTime, currentTime, slowTime } );
        sequences = frac(sequences);


        const float fr0 = lerp(
            frequencyForNote( note_value, 1 ),
            frequencyForNote( note_value_nx, 1 ),
            noteMix
        );
        const float fr1 = lerp(
            frequencyForNote( note_value, 2 ),
            frequencyForNote( note_value_nx, 2 ),
            noteMix
        );
        const float fr2 = lerp(
            frequencyForNote( note_value, 3 ),
            frequencyForNote( note_value_nx, 3 ),
            noteMixS1
        );
        const float fr3 = lerp(
            frequencyForNote( note_value, 4 ),
            frequencyForNote( note_value_nx, 4 ),
            noteMixS2
        );

        const float gate_rate_1 = evaluateEnvelope( env3, sequences.y ) * 15.0f;
        const float gate_rate_2 = evaluateEnvelope( env2, sequences.w ) * 3.0f;

        ispc_construct( float4 frequencyA, { fr1, fr2, fr3, fr0 } );
        ispc_construct( float4 frequencyB, { 4.0f + gate_rate_1 - gate_rate_2, 0.333f, 0.0f, 0.0f } );

        frequencyA  = frequencyA * timeVec.x;
        frequencyB  = frequencyB * timeVec.x;

        const float gate   = smoothstep( 1.0f, 0.6f, oscSquareMorphic( frequencyB.x, 0.15f ) * evaluateEnvelope( env2, 1.0f - sequences.y ) );

        float so  = oscSawtoothMorphic( frequencyA.x, 0.25f + evaluateEnvelope( env3, sequences.x ) ) * evaluateEnvelope( env1, sequences.x ) * gate * 0.3333f;
              so += oscSquareMorphic(   frequencyA.y, 0.25f + evaluateEnvelope( env3, sequences.z ) ) * evaluateEnvelope( env2, sequences.y ) * gate * 0.3333f;
              so += oscSawtoothMorphic( frequencyA.z, 0.25f + evaluateEnvelope( env2, sequences.y ) ) * evaluateEnvelope( env3, sequences.z ) * gate * 0.3333f;

        float bass  = oscTriangleMorphic( frequencyA.w, 0.15f ) * evaluateEnvelope( env4, sequences.z ) * 0.3f;
              bass += (oscTriangleMorphic( frequencyA.w - 0.1f, 0.2f  ) * 
                       oscSawtoothMorphic( frequencyA.w + 0.1f, 0.24f ) * 
                       oscSawtoothMorphic( frequencyA.w + 0.2f, 0.28f )) * evaluateEnvelope( env4, sequences.w ) * 0.7f;

        float pan = oscSquareMorphic( frequencyB.y, 0.4f );

        sample_left_channel[sampleIndex]  = lerp( so, bass, pan );
        sample_right_channel[sampleIndex] = lerp( bass, so, pan );
    }


    // -----------------------------------------------------------------------------------------------------------------

    uniform const float delayFeedback       = dbToGain( -14.0f );

    uniform const int fxBufferStart         = ( time_start * sample_rate ) & fx_buffer_length_maskable;

    // delay effect; in serial mode, we use a standard for-loop to process each sample in turn
    //               in ISPC mode, we are going to jump in blocks and process as many as our target width is set to at once
#ifdef TETHER_COMPILE_SERIAL
    for ( int sampleIndex = 0, delayBufferIndex = fxBufferStart;
          sampleIndex < totalSamples;
          ++ sampleIndex, delayBufferIndex = ( ++ delayBufferIndex ) & fx_buffer_length_maskable  )
#else
    for ( uniform int sampleIndex = 0, delayBufferIndex = fxBufferStart;
          sampleIndex < totalSamples;
          sampleIndex += programCount, delayBufferIndex = ( delayBufferIndex + programCount ) & fx_buffer_length_maskable )
#endif

    // NOTE: that in ISPC mode we make the assumption here that both the sample buffer and delayBufferLength are divisible by programCount, 
    // which in the case of the default (sample rate, eg 48000) is true, but if we wanted a more general case 
    // we would need to back fill the end samples that were left afterwards

    {
        // in serial mode, just use the current counters; in ISPC mode, we differentiate inside the gang by programIndex (and wrap the delay write)
#ifdef TETHER_COMPILE_SERIAL
        const int sampleReadIndex = sampleIndex;
        const int delayWriteIndex = delayBufferIndex;
#else
        const int sampleReadIndex = sampleIndex + programIndex;
        const int delayWriteIndex = ( delayBufferIndex + programIndex ) & fx_buffer_length_maskable;
#endif

        float sampleLeft    = sample_left_channel[sampleReadIndex];
        float sampleRight   = sample_right_channel[sampleReadIndex];

        sampleLeft  += fx_buffer_left_channel[delayWriteIndex];
        sampleRight += fx_buffer_right_channel[delayWriteIndex];

        sample_left_channel[sampleReadIndex]  = softClip( sampleLeft );
        sample_right_channel[sampleReadIndex] = softClip( sampleRight );

        fx_buffer_left_channel[delayWriteIndex]    = sampleLeft * delayFeedback;
        fx_buffer_right_channel[delayWriteIndex]   = sampleRight * delayFeedback;
    }
}
