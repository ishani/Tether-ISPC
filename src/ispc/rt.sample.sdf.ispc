// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// take a stack of [base polygon + hole polygons] and produce SDF ouput with -ve outside, +ve inside
// given a [w,h] block of output and a remapping of world-space coordinates to that [w,h]
//
// contains iq's Polygon distance function from https://www.iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm
//

#include "common.isph"


// ------------------------------------------------------------------------------------------------

export void polygonsToSDF( 
    uniform const float2 vertices[],        // vertex coordinates
    uniform const int    polygonSizes[],    // array of polys, each element defining the number of vertices; all elements beyond the first are assumed to be holes in the primary one
    uniform const int    polygonCount,      // number of elements in `polygonSizes`
    uniform float        sdf_output[],      // [ sdf_output_width x sdf_output_height ] SDF output of fp values
    uniform int          sdf_output_width,
    uniform int          sdf_output_height,
    uniform const float  world_start_x,     // define the world-space area of the SDF output, [ws_x,ws_y] [ws_w,ws_h]
    uniform const float  world_start_y,
    uniform const float  world_size_x,
    uniform const float  world_size_y
    )
{
    // map field output size to physical dimensions
    uniform const float rangeX = world_size_x / (float)sdf_output_width;
    uniform const float rangeY = world_size_y / (float)sdf_output_height;

    // launch work across 2D domain
    tiled_iteration_xy( int, sdf_output_width, sdf_output_height )
    {
        // result value that gets written to sdf_output
        float gathered_dist = 0;

        // produce some location coordinate in the same space as the input polys
        const float pX = world_start_x + ( (float)x * rangeX );
        const float pY = world_start_y + ( (float)y * rangeY );

        // walk the input and produce a signed distance and a rolling record of flip-bits
        {
            ispc_construct( const float2 p, { pX, pY } );

            // iterate through the list of polygon lengths; 0 .. [0], [0] .. [1], etc
            uniform int readOffset = 0;
            for (uniform int spI = 0; spI < polygonCount; ++spI) 
            {
                uniform int nverts = polygonSizes[ spI ];

                float dist = C_FLT_MAX;      // working distance value
                float flip = 1.0f;           // sign-flip as we change winding (http://geomalgorithms.com/a03-_inclusion.html)

                // j loops one back from i
                for ( uniform int i = 0, j = nverts - 1; i < nverts; j = i, ++i )
                {
                    uniform const float2 vert_i = vertices[ readOffset + i ];
                    uniform const float2 vert_j = vertices[ readOffset + j ];

                    uniform const float2 dist_ij    = ( vert_j - vert_i );
                    uniform const float sqr_dist_ij = dot( dist_ij, dist_ij );

                    const float2 dist_pi   = p - vert_i;
                    const float diff_ij_pi = dot( dist_ij, dist_pi );

                    const float2 dtl       = dist_pi - ( dist_ij * saturate( diff_ij_pi / sqr_dist_ij ) );
                    const float sqr_dist   = dot( dtl, dtl );

                    dist = _fmin( dist, sqr_dist );

                    // conditions that need to be all() or none() to flip the sign 
                    const bool c1 = p.y >= vert_i.y;
                    const bool c2 = p.y <  vert_j.y;
                    const bool c3 = ( dist_ij.x * dist_pi.y ) > ( dist_ij.y * dist_pi.x );

                    // flip the sign tracking if we're inside or outside
                    if ( (  c1 &  c2 &  c3 ) || ( !c1 & !c2 & !c3 ) )
                    {
                        flip *= -1.0f;
                    }
                }

                // distort with a noise field
                ispc_construct( const float2 nP2, { pX * 0.75f, pY * 0.75f } );
                const float noise_distortion = cellular2D(nP2);

                const float signed_dist = ( STDN sqrt( dist ) * flip ) + ( noise_distortion * noise_distortion * 1.5f );


                // on first pass, store the base distance
                if ( readOffset == 0 )
                    gathered_dist = signed_dist;
                // other passes are holes, so subtract them from the existing field
                else
                    gathered_dist = sdfSubtraction( signed_dist, gathered_dist );

                readOffset += nverts;
            }
        }

        // scatter into output buffer
        int offset = ( y * sdf_output_width ) + x;

        // #pragma ignore warning(perf)
        sdf_output[ offset ] = gathered_dist;
    }
}