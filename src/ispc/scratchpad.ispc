

#include "common.isph"

export uniform bool scratchpad(
    uniform const unsigned int8 first[],
    uniform const unsigned int8 second[],
    uniform const unsigned int32 inputLength )
{
    for (uniform int i = 0; i < inputLength; i += programCount)
    {
        bool eq = first[i + programIndex] == second[i + programIndex];
        if ( !all(eq) )
            return false;
    }

    return true;
}