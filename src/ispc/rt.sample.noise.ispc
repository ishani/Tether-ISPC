// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// ISPC port of iq Noise shader; https://www.shadertoy.com/view/4sfGzS
//

#include "common.isph"


// ------------------------------------------------------------------------------------------------

export void renderImageNoiseBall( 
    uniform const uint32_t  output_width,
    uniform const uint32_t  output_height,
    uniform uint32_t        output[],
    uniform const uint32_t  output_pitch
    )
{
    uniform const float float_width  = (float) output_width;
    uniform const float float_height = (float) output_height;
    uniform const float recp_width   = 1.0f / float_width;
    uniform const float recp_height  = 1.0f / float_height;

    ispc_construct( uniform static const float3 m_1, { 0.00f,  0.80f,  0.60f } );
    ispc_construct( uniform static const float3 m_2, { -0.80f,  0.36f, -0.48f } );
    ispc_construct( uniform static const float3 m_3, { -0.60f, -0.48f,  0.64f } );
    ispc_construct_struct( uniform float3x3 m, { m_1, m_2, m_3 } );


    ispc_construct_float3_single( static const float3 f3_000, 0.0f );
    ispc_construct( uniform static const float3 f3_010, { 0.0f, 1.0f, 0.0f } );

    ispc_construct( static const float3 f3_red, { 1.0f, 0.2f, 0.0f } );
    ispc_construct( static const float3 f3_blue, { 0.0f, 0.2f, 1.0f } );

    tiled_iteration_xy( uint32_t, output_width, output_height )
    {
        float dx = ( ( -float_width  ) + (float)(2 * x) ) * recp_height;
        float dy = ( (  float_height ) - (float)(2 * y) ) * recp_height;
        
        {
            float an = 0.5;
            float an_c, an_s;
            sincos(an, &an_s, &an_c);

            ispc_construct( float3 ro, { 2.5f * an_c, 1.0f, 2.5f * an_s } );
            float3 ta = f3_010;

            // camera matrix
            float3 ww = normalized( ta - ro );
            float3 uu = normalized( cross( ww, f3_010 ) );
            float3 vv = normalized( cross( uu, ww ) );

            // create view ray
            float3 rd = normalized( dx * uu + dy * vv + 1.5f * ww );

            // sphere center
            float3 sc = f3_010;

            // raytrace
            float tmin  = 10000.0f;
            float3 nor  = f3_000;
            float occ   = 1.0f;
            float3 pos  = f3_000;

            // raytrace-plane
            float h = (0.0f - ro.y) / rd.y;
            if( h > 0.0f ) 
            { 
                tmin = h; 
                nor = f3_010; 
                pos = ro + h*rd;
                float3 di = sc - pos;
                float l = length(di);
                occ = 1.0f - dot(nor,di/l) * 1.0f * 1.0f / (l*l); 
            }

            // raytrace-sphere
            float3  ce = ro - sc;
            float b = dot( rd, ce );
            float c = dot( ce, ce ) - 1.0f;
            h = b*b - c;
            if( h > 0.0f )
            {
                h = -b - sqrt(h);
                if( h<tmin )
                { 
                    tmin=h;
                    nor = normalized( ro + h * rd - sc ); 
                    occ = 0.5f + 0.5f * nor.y;
                }
            }

            // shading/lighting
            float3 col = Float3(0.9f);
            if( tmin < 100.0f )
            {
                pos = ro + tmin*rd;
                float f = 0.0f;
        
                if( dx < 0.0f )
                {
                    f = noise( 16.0f * pos );
                }
                else
                {
                    float3 q = 8.0f * pos;
                    f  = 0.5000f * noise( q ); q = mul( m, q ) * 2.01f;
                    f += 0.2500f * noise( q ); q = mul( m, q ) * 2.02f;
                    f += 0.1250f * noise( q ); q = mul( m, q ) * 2.03f;
                    f += 0.0625f * noise( q ); q = mul( m, q ) * 2.01f;
                }

                float3 point9 = Float3( 0.9f );

                f *= occ;
                col = Float3( f * 1.2f );
                col = lerp( col, point9, 1.0f - exp( -0.003f * tmin * tmin ) );
            }

            col  = sqrt( col );
            col *= smoothstep( 0.006f, 0.008f, abs(dx) );


            uint32_t offset_out = ( y * output_pitch ) + x;

            output[offset_out] = rgbFloatToU32( cosineGradientRainbow( sum(col) * 0.3333f ) );
        }
    }
}

