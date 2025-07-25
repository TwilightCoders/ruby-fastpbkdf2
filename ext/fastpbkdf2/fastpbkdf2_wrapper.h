/*
 * fastpbkdf2_wrapper.h - Platform compatibility wrapper for fastpbkdf2
 * 
 * This header handles platform-specific differences without modifying
 * the upstream fastpbkdf2 source files.
 */

#ifndef FASTPBKDF2_WRAPPER_H
#define FASTPBKDF2_WRAPPER_H

/* Platform-specific compatibility fixes */
#ifdef __APPLE__
  /* On macOS, we have __GNUC__ but don't want to use the GCC-specific 
   * endian.h and __BYTE_ORDER checks. Let's define the endian macros
   * we need using the Apple-specific headers instead. */
  #include <machine/endian.h>
  #include <libkern/OSByteOrder.h>
  
  /* Define the Linux-style endian macros that fastpbkdf2.c expects */
  #ifndef __BYTE_ORDER
    #define __BYTE_ORDER    BYTE_ORDER
  #endif
  #ifndef __LITTLE_ENDIAN
    #define __LITTLE_ENDIAN LITTLE_ENDIAN
  #endif
  #ifndef __BIG_ENDIAN
    #define __BIG_ENDIAN    BIG_ENDIAN
  #endif
#endif

/* Windows platform compatibility fixes */
#ifdef _WIN32
  /* Windows doesn't have endian.h, but it's always little-endian on x86/x64 */
  #ifndef __BYTE_ORDER
    #define __BYTE_ORDER    1234
  #endif
  #ifndef __LITTLE_ENDIAN
    #define __LITTLE_ENDIAN 1234
  #endif
  #ifndef __BIG_ENDIAN
    #define __BIG_ENDIAN    4321
  #endif
#endif

/* Include the actual fastpbkdf2 header */
#include "../../vendor/fastpbkdf2/fastpbkdf2.h"

#endif /* FASTPBKDF2_WRAPPER_H */
