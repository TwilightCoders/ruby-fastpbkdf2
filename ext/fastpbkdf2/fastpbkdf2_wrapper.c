/*
 * fastpbkdf2_wrapper.c - Platform compatibility wrapper for fastpbkdf2
 * 
 * This wrapper sets up the proper environment for fastpbkdf2.c compilation
 * without modifying the upstream source files.
 */

/* 
 * fastpbkdf2_wrapper.c - Cross-platform wrapper for fastpbkdf2.c
 * 
 * This wrapper includes fastpbkdf2.c with cross-platform endian compatibility.
 * The local endian.h file handles platform differences automatically.
 */

/* Now include the actual fastpbkdf2.c implementation */
#include "../../vendor/fastpbkdf2/fastpbkdf2.c"
