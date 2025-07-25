/*
 * fastpbkdf2_wrapper.c - Platform compatibility wrapper for fastpbkdf2
 * 
 * This wrapper sets up the proper environment for fastpbkdf2.c compilation
 * without modifying the upstream source files.
 */

/* Set up platform-specific environment before including fastpbkdf2.c */
#ifdef __APPLE__
  /* On macOS, define the endian macros that fastpbkdf2.c expects */
  #include <machine/endian.h>
  #include <libkern/OSByteOrder.h>
  
  /* Define the Linux-style endian macros */
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

/* Now include the actual fastpbkdf2.c implementation */
#include "../../vendor/fastpbkdf2/fastpbkdf2.c"