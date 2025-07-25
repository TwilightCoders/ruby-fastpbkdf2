/*
 * fastpbkdf2_wrapper.c - Platform compatibility wrapper for fastpbkdf2
 * 
 * This wrapper sets up the proper environment for fastpbkdf2.c compilation
 * without modifying the upstream source files.
 */

/* Set up platform-specific environment before including fastpbkdf2.c */
#ifdef __APPLE__
  /* On macOS, we need to provide the endian.h functionality */
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
  
  /* Redefine __GNUC__ temporarily to prevent endian.h include in fastpbkdf2.c */
  #ifdef __GNUC__
    #define __FASTPBKDF2_SAVED_GNUC__ __GNUC__
    #undef __GNUC__
  #endif
#endif

/* Now include the actual fastpbkdf2.c implementation */
#include "../../vendor/fastpbkdf2/fastpbkdf2.c"

#ifdef __APPLE__
  /* Restore __GNUC__ if it was defined */
  #ifdef __FASTPBKDF2_SAVED_GNUC__
    #define __GNUC__ __FASTPBKDF2_SAVED_GNUC__
    #undef __FASTPBKDF2_SAVED_GNUC__
  #endif
#endif
