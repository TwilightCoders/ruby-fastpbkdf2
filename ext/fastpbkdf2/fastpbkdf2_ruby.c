#include <ruby.h>
#include "fastpbkdf2_wrapper.h"

static VALUE mFastpbkdf2;
static unsigned long fastpbkdf2_iteration_warn_threshold = 1000000UL; /* default soft warning at 1M */

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

    VALUE iter_val = rb_to_int(iterations);
    VALUE len_val  = rb_to_int(length);

    unsigned long iter_ul = NUM2ULONG(iter_val);
    unsigned long len_ul  = NUM2ULONG(len_val);

    if (iter_ul == 0 || iter_ul > UINT32_MAX) {
        rb_raise(rb_eArgError, "iterations must be between 1 and %u", UINT32_MAX);
    }
        if (fastpbkdf2_iteration_warn_threshold && iter_ul > fastpbkdf2_iteration_warn_threshold) {
            rb_warn("FastPBKDF2: iteration count %lu exceeds soft warning threshold %lu", iter_ul, fastpbkdf2_iteration_warn_threshold);
        }
    if (len_ul == 0) {
        rb_raise(rb_eArgError, "length must be greater than 0");
    }

    /* Basic sanity limit to avoid pathological allocations (256MB cap) */
    if (len_ul > (256UL * 1024UL * 1024UL)) {
        rb_raise(rb_eArgError, "length too large (max 256MB)");
    }

    const uint8_t *pw = (const uint8_t *)RSTRING_PTR(password);
    size_t npw = RSTRING_LEN(password);
    const uint8_t *salt_ptr = (const uint8_t *)RSTRING_PTR(salt);
    size_t nsalt = RSTRING_LEN(salt);
    uint32_t iter = (uint32_t)iter_ul;
    size_t nout = (size_t)len_ul;

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

    VALUE iter_val = rb_to_int(iterations);
    VALUE len_val  = rb_to_int(length);

    unsigned long iter_ul = NUM2ULONG(iter_val);
    unsigned long len_ul  = NUM2ULONG(len_val);

    if (iter_ul == 0 || iter_ul > UINT32_MAX) {
        rb_raise(rb_eArgError, "iterations must be between 1 and %u", UINT32_MAX);
    }
        if (fastpbkdf2_iteration_warn_threshold && iter_ul > fastpbkdf2_iteration_warn_threshold) {
            rb_warn("FastPBKDF2: iteration count %lu exceeds soft warning threshold %lu", iter_ul, fastpbkdf2_iteration_warn_threshold);
        }
    if (len_ul == 0) {
        rb_raise(rb_eArgError, "length must be greater than 0");
    }
    if (len_ul > (256UL * 1024UL * 1024UL)) {
        rb_raise(rb_eArgError, "length too large (max 256MB)");
    }

    const uint8_t *pw = (const uint8_t *)RSTRING_PTR(password);
    size_t npw = RSTRING_LEN(password);
    const uint8_t *salt_ptr = (const uint8_t *)RSTRING_PTR(salt);
    size_t nsalt = RSTRING_LEN(salt);
    uint32_t iter = (uint32_t)iter_ul;
    size_t nout = (size_t)len_ul;

    VALUE result = rb_str_new(NULL, nout);
    uint8_t *out = (uint8_t *)RSTRING_PTR(result);

    fastpbkdf2_hmac_sha256(pw, npw, salt_ptr, nsalt, iter, out, nout);

    return result;
}

/* Secure constant-time compare */
static VALUE rb_fastpbkdf2_secure_compare(VALUE self __attribute__((unused)), VALUE a, VALUE b) {
    Check_Type(a, T_STRING);
    Check_Type(b, T_STRING);
    long la = RSTRING_LEN(a);
    long lb = RSTRING_LEN(b);
    if (la != lb) return Qfalse;
    const unsigned char *pa = (const unsigned char *)RSTRING_PTR(a);
    const unsigned char *pb = (const unsigned char *)RSTRING_PTR(b);
    unsigned int diff = 0;
    for (long i = 0; i < la; i++) {
        diff |= (unsigned int)(pa[i] ^ pb[i]);
    }
    return diff == 0 ? Qtrue : Qfalse;
}

/* Iteration warning threshold setters/getters */
static VALUE rb_fastpbkdf2_set_iter_warn(VALUE self __attribute__((unused)), VALUE threshold) {
    threshold = rb_to_int(threshold);
    unsigned long val = NUM2ULONG(threshold);
    fastpbkdf2_iteration_warn_threshold = val;
    return ULONG2NUM(val);
}

static VALUE rb_fastpbkdf2_get_iter_warn(VALUE self __attribute__((unused))) {
    return ULONG2NUM(fastpbkdf2_iteration_warn_threshold);
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

    VALUE iter_val = rb_to_int(iterations);
    VALUE len_val  = rb_to_int(length);

    unsigned long iter_ul = NUM2ULONG(iter_val);
    unsigned long len_ul  = NUM2ULONG(len_val);

    if (iter_ul == 0 || iter_ul > UINT32_MAX) {
        rb_raise(rb_eArgError, "iterations must be between 1 and %u", UINT32_MAX);
    }
        if (fastpbkdf2_iteration_warn_threshold && iter_ul > fastpbkdf2_iteration_warn_threshold) {
            rb_warn("FastPBKDF2: iteration count %lu exceeds soft warning threshold %lu", iter_ul, fastpbkdf2_iteration_warn_threshold);
        }
    if (len_ul == 0) {
        rb_raise(rb_eArgError, "length must be greater than 0");
    }
    if (len_ul > (256UL * 1024UL * 1024UL)) {
        rb_raise(rb_eArgError, "length too large (max 256MB)");
    }

    const uint8_t *pw = (const uint8_t *)RSTRING_PTR(password);
    size_t npw = RSTRING_LEN(password);
    const uint8_t *salt_ptr = (const uint8_t *)RSTRING_PTR(salt);
    size_t nsalt = RSTRING_LEN(salt);
    uint32_t iter = (uint32_t)iter_ul;
    size_t nout = (size_t)len_ul;

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

    /* Soft iteration warning threshold accessor */
    rb_define_singleton_method(mFastpbkdf2, "iteration_warning_threshold=", RUBY_METHOD_FUNC(rb_fastpbkdf2_set_iter_warn), 1);
    rb_define_singleton_method(mFastpbkdf2, "iteration_warning_threshold", RUBY_METHOD_FUNC(rb_fastpbkdf2_get_iter_warn), 0);
    rb_define_singleton_method(mFastpbkdf2, "secure_compare", RUBY_METHOD_FUNC(rb_fastpbkdf2_secure_compare), 2);
}
