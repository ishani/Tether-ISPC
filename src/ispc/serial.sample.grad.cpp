// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// 
//

#include "serial.common.h"

TETHER_SERIAL_NAMESPACE_OPEN

void foo()
{
    for ( float x = 0.0f; x <= 1.0f; x += 0.1f )
    {
        float3 t = gradient_rainbow( x );
        printf( "%f, %f, %f\n", t.x, t.y, t.z );
    }
}


TETHER_SERIAL_NAMESPACE_CLOSE

