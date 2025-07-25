/*
 * endian.h - Cross-platform endian compatibility header
 * 
 * This file provides endian.h compatibility for platforms that don't have it
 * (like Windows and macOS). It gets included by fastpbkdf2.c when __GNUC__ is defined.
 */

#ifndef FASTPBKDF2_ENDIAN_H
#define FASTPBKDF2_ENDIAN_H

#ifdef __APPLE__
  /* macOS approach: use system headers to define endian macros */ 
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

#elif defined(_WIN32)
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

#else
  /* Linux and other Unix systems - include the real system endian.h */
  #if __has_include(<endian.h>)
    #include_next <endian.h>
  #elif __has_include(<sys/endian.h>)
    #include <sys/endian.h>
  #else
    /* Fallback definitions for systems without endian headers */
    #ifndef __BYTE_ORDER
      #ifdef __BYTE_ORDER__
        #define __BYTE_ORDER __BYTE_ORDER__
      #else
        #define __BYTE_ORDER 1234  /* Assume little-endian */
      #endif
    #endif
    #ifndef __LITTLE_ENDIAN
      #ifdef __ORDER_LITTLE_ENDIAN__
        #define __LITTLE_ENDIAN __ORDER_LITTLE_ENDIAN__
      #else
        #define __LITTLE_ENDIAN 1234
      #endif
    #endif
    #ifndef __BIG_ENDIAN
      #ifdef __ORDER_BIG_ENDIAN__
        #define __BIG_ENDIAN __ORDER_BIG_ENDIAN__
      #else
        #define __BIG_ENDIAN 4321
      #endif
    #endif
  #endif
#endif

#endif /* FASTPBKDF2_ENDIAN_H */
