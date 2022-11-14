/// Work around some MSVC-specific features
#define wchar_t short
#define _WCHAR_T_DEFINED
#define __int8 int
#define __int16 int
#define __int32 int
#define __int64 int
#define __cdecl
#define __pragma(x)
#define __inline
#define __forceinline
#define __ptr32
#define __ptr64
#define __unaligned
#define __stdcall
#define _stdcall
#define __alignof(x) 1
#define __declspec(x)
#define _declspec(x)

/// Work around GCC-specific features
#define __builtin_va_list void

#if defined(__WCHAR_TYPE__)
#undef wchar_t
#endif // defined(__WCHAR_TYPE__)
#define __restrict
#define __attribute__(va)
#define __asm__(x)

#include "../Sources/CZ3/api/z3.h"
