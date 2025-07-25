#include <ruby.h>
#include "fastpbkdf2_wrapper.h"

static VALUE mFastpbkdf2;

/*
 * call-seq:
 *   FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, length) -> String
 *
 * Calculates PBKDF2-HMAC-SHA1 and returns the derived key as a binary string.
 *
 * * +password+ - Password string or binary data
 * * +salt+ - Salt string or binary data  
 * * +iterations+ - Number of iterations (must be > 0)
 * * +length+ - Length of output key in bytes (must be > 0)
 */
static VALUE
rb_fastpbkdf2_hmac_sha1(VALUE self __attribute__((unused)), VALUE password, VALUE salt, VALUE iterations, VALUE length)
{
    Check_Type(password, T_STRING);
    Check_Type(salt, T_STRING);
    Check_Type(iterations, T_FIXNUM);
    Check_Type(length, T_FIXNUM);
    
    const uint8_t *pw = (const uint8_t *)RSTRING_PTR(password);
    size_t npw = RSTRING_LEN(password);
    const uint8_t *salt_ptr = (const uint8_t *)RSTRING_PTR(salt);
    size_t nsalt = RSTRING_LEN(salt);
    uint32_t iter = NUM2UINT(iterations);
    size_t nout = NUM2UINT(length);
    
    if (iter == 0) {
        rb_raise(rb_eArgError, "iterations must be greater than 0");
    }
    if (nout == 0) {
        rb_raise(rb_eArgError, "length must be greater than 0");
    }
    
    VALUE result = rb_str_new(NULL, nout);
    uint8_t *out = (uint8_t *)RSTRING_PTR(result);
    
    fastpbkdf2_hmac_sha1(pw, npw, salt_ptr, nsalt, iter, out, nout);
    
    return result;
}

/*
 * call-seq:
 *   FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length) -> String
 *
 * Calculates PBKDF2-HMAC-SHA256 and returns the derived key as a binary string.
 *
 * * +password+ - Password string or binary data
 * * +salt+ - Salt string or binary data  
 * * +iterations+ - Number of iterations (must be > 0)
 * * +length+ - Length of output key in bytes (must be > 0)
 */
static VALUE
rb_fastpbkdf2_hmac_sha256(VALUE self __attribute__((unused)), VALUE password, VALUE salt, VALUE iterations, VALUE length)
{
    Check_Type(password, T_STRING);
    Check_Type(salt, T_STRING);
    Check_Type(iterations, T_FIXNUM);
    Check_Type(length, T_FIXNUM);
    
    const uint8_t *pw = (const uint8_t *)RSTRING_PTR(password);
    size_t npw = RSTRING_LEN(password);
    const uint8_t *salt_ptr = (const uint8_t *)RSTRING_PTR(salt);
    size_t nsalt = RSTRING_LEN(salt);
    uint32_t iter = NUM2UINT(iterations);
    size_t nout = NUM2UINT(length);
    
    if (iter == 0) {
        rb_raise(rb_eArgError, "iterations must be greater than 0");
    }
    if (nout == 0) {
        rb_raise(rb_eArgError, "length must be greater than 0");
    }
    
    VALUE result = rb_str_new(NULL, nout);
    uint8_t *out = (uint8_t *)RSTRING_PTR(result);
    
    fastpbkdf2_hmac_sha256(pw, npw, salt_ptr, nsalt, iter, out, nout);
    
    return result;
}

/*
 * call-seq:
 *   FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations, length) -> String
 *
 * Calculates PBKDF2-HMAC-SHA512 and returns the derived key as a binary string.
 *
 * * +password+ - Password string or binary data
 * * +salt+ - Salt string or binary data  
 * * +iterations+ - Number of iterations (must be > 0)
 * * +length+ - Length of output key in bytes (must be > 0)
 */
static VALUE
rb_fastpbkdf2_hmac_sha512(VALUE self __attribute__((unused)), VALUE password, VALUE salt, VALUE iterations, VALUE length)
{
    Check_Type(password, T_STRING);
    Check_Type(salt, T_STRING);
    Check_Type(iterations, T_FIXNUM);
    Check_Type(length, T_FIXNUM);
    
    const uint8_t *pw = (const uint8_t *)RSTRING_PTR(password);
    size_t npw = RSTRING_LEN(password);
    const uint8_t *salt_ptr = (const uint8_t *)RSTRING_PTR(salt);
    size_t nsalt = RSTRING_LEN(salt);
    uint32_t iter = NUM2UINT(iterations);
    size_t nout = NUM2UINT(length);
    
    if (iter == 0) {
        rb_raise(rb_eArgError, "iterations must be greater than 0");
    }
    if (nout == 0) {
        rb_raise(rb_eArgError, "length must be greater than 0");
    }
    
    VALUE result = rb_str_new(NULL, nout);
    uint8_t *out = (uint8_t *)RSTRING_PTR(result);
    
    fastpbkdf2_hmac_sha512(pw, npw, salt_ptr, nsalt, iter, out, nout);
    
    return result;
}

void
Init_fastpbkdf2(void)
{
    mFastpbkdf2 = rb_define_module("FastPBKDF2");
    
    rb_define_module_function(mFastpbkdf2, "pbkdf2_hmac_sha1", rb_fastpbkdf2_hmac_sha1, 4);
    rb_define_module_function(mFastpbkdf2, "pbkdf2_hmac_sha256", rb_fastpbkdf2_hmac_sha256, 4);
    rb_define_module_function(mFastpbkdf2, "pbkdf2_hmac_sha512", rb_fastpbkdf2_hmac_sha512, 4);
    
    // Add shorter, cleaner aliases using rb_define_alias
    rb_define_alias(rb_singleton_class(mFastpbkdf2), "sha1", "pbkdf2_hmac_sha1");
    rb_define_alias(rb_singleton_class(mFastpbkdf2), "sha256", "pbkdf2_hmac_sha256");
    rb_define_alias(rb_singleton_class(mFastpbkdf2), "sha512", "pbkdf2_hmac_sha512");
}
