// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// replacing the common.isph configuration header with setup required to compile ISPC code as regular serial C++
// NOTE this isn't an exhaustive emulation layer, there are keywords and functions that ISPC has that are not supported yet
//

#define NOMINMAX

// configure compilation to ignore common.isph or other default includes in .ispc files, as we are replacing their
// function with C++ variants
#define TETHER_COMPILE_SERIAL

#define TETHER_SERIAL_NAMESPACE_OPEN    namespace serial {
#define TETHER_SERIAL_NAMESPACE_CLOSE   }


#include <cstdlib>
#include <cmath>
#include <cfloat>
#include <cassert>
#include <algorithm>
#include <inttypes.h>
#include <memory>
#include <string.h>

using int64     = int64_t;
using uint      = uint32_t;
using uint64    = uint64_t;


// ---------------------------------------------------------------------------------------------------------------------
// emulate ISPC vector and matrix types
//

#include <swizzle/glsl/naive/vector.h>

using float2 = swizzle::glsl::naive::vector< float, 2 >;
using float3 = swizzle::glsl::naive::vector< float, 3 >;
using float4 = swizzle::glsl::naive::vector< float, 4 >;

using int2   = swizzle::glsl::naive::vector< int, 2 >;
using int3   = swizzle::glsl::naive::vector< int, 3 >;
using int4   = swizzle::glsl::naive::vector< int, 4 >;

using uint2  = swizzle::glsl::naive::vector< uint, 2 >;
using uint3  = swizzle::glsl::naive::vector< uint, 3 >;
using uint4  = swizzle::glsl::naive::vector< uint, 4 >;

using bool2  = swizzle::glsl::naive::vector< bool, 2 >;
using bool3  = swizzle::glsl::naive::vector< bool, 3 >;
using bool4  = swizzle::glsl::naive::vector< bool, 4 >;

static_assert(sizeof(float2) == sizeof(float[2]), "float2 is not expected size");
static_assert(sizeof(float3) == sizeof(float[3]), "float3 is not expected size");
static_assert(sizeof(float4) == sizeof(float[4]), "float4 is not expected size");


#define MATRIX_BRACKET( _max )                                  \
    inline float##_max operator [] (const uint32_t idx) const   \
    {                                                           \
        if ( idx < _max )                                       \
            return row[ idx ];                                  \
        assert(0 && "idx out of bounds:" #_max); abort();       \
    }                                                           \
    inline float##_max& operator [] (const uint32_t idx)        \
    {                                                           \
        if ( idx < _max )                                       \
            return row[ idx ];                                  \
        assert(0 && "idx out of bounds:" #_max); abort();       \
    }

struct float2x2
{
    float2 row[2];

    inline float2x2(const float2& r0, const float2& r1)
    {
        row[0] = r0;
        row[1] = r1;
    }

    inline float2x2() = default;

    MATRIX_BRACKET(2);
};

struct float3x3
{
    float3 row[3];

    inline float3x3(const float3& r0, const float3& r1, const float3& r2)
    {
        row[0] = r0;
        row[1] = r1;
        row[2] = r2;
    }

    inline float3x3() = default;

    MATRIX_BRACKET(3);
};

struct float4x4
{
    float4 row[4];

    inline float4x4(const float4& r0, const float4& r1, const float4& r2, const float4& r3)
    {
        row[0] = r0;
        row[1] = r1;
        row[2] = r2;
        row[3] = r3;
    }

    inline float4x4() = default;

    MATRIX_BRACKET(4);
};

#undef MATRIX_BRACKET



// ---------------------------------------------------------------------------------------------------------------------
// custom RNG functions - ported from the ISPC standard library 
// they are not particularly fast; there is a simpler one in common.random.inl.isph (but still with good distribution)

inline float floatbits(const uint32_t u32)
{
    float ret;
    memcpy(&ret, &u32, sizeof(float));
    return ret;
}

struct RNGState 
{
    uint32_t z1, z2, z3, z4;
};

inline void seed_rng(RNGState* state, uint32_t seed) 
{
    state->z1 = seed;
    state->z2 = seed ^ 0xbeeff00d;
    state->z3 = ((seed & 0xfffful) << 16) | (seed >> 16);
    state->z4 = (((seed & 0xfful) << 24) | ((seed & 0xff00ul) << 8) |
                ((seed & 0xff0000ul) >> 8) | (seed & 0xff000000ul) >> 24);
}

inline uint32_t random(RNGState* state)
{
    uint32_t b;

    b         = ((state->z1 << 6) ^ state->z1) >> 13;
    state->z1 = ((state->z1 & 4294967294U) << 18) ^ b;
    b         = ((state->z2 << 2) ^ state->z2) >> 27;
    state->z2 = ((state->z2 & 4294967288U) << 2) ^ b;
    b         = ((state->z3 << 13) ^ state->z3) >> 21;
    state->z3 = ((state->z3 & 4294967280U) << 7) ^ b;
    b         = ((state->z4 << 3) ^ state->z4) >> 12;
    state->z4 = ((state->z4 & 4294967168U) << 13) ^ b;
    return (state->z1 ^ state->z2 ^ state->z3 ^ state->z4);
}

inline float frandom(RNGState* state)
{
    uint32_t irand  = random(state);
             irand &= (1ul << 23) - 1;

    return floatbits(0x3F800000 | irand) - 1.0f;
}


// ---------------------------------------------------------------------------------------------------------------------
// remove or replace a few bespoke keywords

#define export
#define uniform
#define cif(...)    if(__VA_ARGS__)

#define reduce_add
#define reduce_min
#define reduce_max

#define tiled_iteration_xy( _type, _width, _height )        \
            for ( _type y = (_type)0; y < _height; y ++ )   \
            for ( _type x = (_type)0; x < _width; x ++ )


// ---------------------------------------------------------------------------------------------------------------------
// construction syntax differs just enough to be annoying, which is why we use macros to wrap and adapt it; more details 
// in common.isph

#define _ctf2  float2
#define _ctf3  float3
#define _ctf4  float4

#define ispc_construct( _decl, ... )            _decl __VA_ARGS__
#define ispc_construct_struct( _decl, ... )     _decl __VA_ARGS__
#define ispc_convert( _toType, _var )           _toType(_var)

#define ispc_construct_float3_single( _decl, _value )    _decl { _value, _value, _value }
#define ispc_construct_float4_single( _decl, _value )    _decl { _value, _value, _value, _value }


// ---------------------------------------------------------------------------------------------------------------------
// define any missing stdlib functions that are considered built-in during common.isph

#define _fmax           std::max
#define _fmin           std::min

// used in _PER_CHANNEL_IMPL, which expects to refer to std:: implementations
namespace std 
{
    inline float rcp(const float v)     { return 1.0f / v; }
    inline float rsqrt(const float v)   { return 1.0f / sqrtf(v); }
}

inline void sincos(const float t, float* out_sin, float* out_cos)
{
    *out_sin = std::sin(t);
    *out_cos = std::cos(t);
}

template<class T>
constexpr const T& clamp(const T& v, const T& lo, const T& hi)
{
    return (v < lo) ? lo : (hi < v) ? hi : v;
}


// ---------------------------------------------------------------------------------------------------------------------

#include "common.macro.inl.isph"

// ---------------------------------------------------------------------------------------------------------------------

#define _TETHER_ONE_PASS   1
#define _TETHER_ARG_0      1
#define _TETHER_ARG_1      1
#define _TETHER_ARG_2      1
#define _TETHER_ARG_3      1

#define _tether_decl        static inline
#define _tether_var         
#define _tether_arg1_decl   
#define _tether_arg2_decl   
#define _tether_arg3_decl   

#define _tether_arg1(_t)        const _tether_arg1_decl _t&
#define _tether_arg2(_t)        const _tether_arg2_decl _t&
#define _tether_arg3(_t)        const _tether_arg3_decl _t&

#define _tether_arg1_float      const _tether_arg1_decl float
#define _tether_arg2_float      const _tether_arg2_decl float
#define _tether_arg3_float      const _tether_arg3_decl float

#define _tether_arg1_double     const _tether_arg1_decl double
#define _tether_arg2_double     const _tether_arg2_decl double
#define _tether_arg3_double     const _tether_arg3_decl double

#include "common.math.inl.isph"
#include "common.matrix.inl.isph"
#include "common.random.inl.isph"
#include "common.noise.inl.isph"
#include "common.utility.inl.isph"
#include "common.sdf.inl.isph"
#include "common.audio.inl.isph"

#undef _tether_arg3_double
#undef _tether_arg2_double
#undef _tether_arg1_double

#undef _tether_arg3_double
#undef _tether_arg2_double
#undef _tether_arg1_double

#undef _tether_arg3
#undef _tether_arg2
#undef _tether_arg1

#undef _tether_arg3_decl
#undef _tether_arg2_decl
#undef _tether_arg1_decl
#undef _tether_var
#undef _tether_decl

#undef _TETHER_ARG_3
#undef _TETHER_ARG_2
#undef _TETHER_ARG_1
#undef _TETHER_ARG_0
#undef _TETHER_ONE_PASS

