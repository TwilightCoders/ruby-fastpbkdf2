require 'mkmf'
require 'fileutils'

# Copy fastpbkdf2 C source files from vendor directory if they exist
# This handles both development (with git submodule) and gem installation (with bundled files)
vendor_dir = File.expand_path('../../vendor/fastpbkdf2', __dir__)
if Dir.exist?(vendor_dir)
  FileUtils.cp(File.join(vendor_dir, 'fastpbkdf2.c'), '.')
  FileUtils.cp(File.join(vendor_dir, 'fastpbkdf2.h'), '.')

  # Apply macOS compatibility fix to fastpbkdf2.c
  content = File.read('fastpbkdf2.c')
  content.gsub!('#if defined(__GNUC__)', '#if defined(__GNUC__) && !defined(__APPLE__)')
  File.write('fastpbkdf2.c', content)
end

# Check for OpenSSL (required by fastpbkdf2)
unless have_library('crypto', 'HMAC_CTX_new')
  abort "OpenSSL libcrypto is required but not found"
end

# Set compilation flags
$CFLAGS << ' -std=c99 -O3 -Wall -Wextra -pedantic'

# Platform-specific flags for fastpbkdf2.c compatibility
if RUBY_PLATFORM =~ /darwin/
  $CFLAGS << ' -D__APPLE__' # Ensure Apple-specific code paths are used
end

# Suppress various warnings for cleaner compilation
$CFLAGS << ' -Wno-deprecated-declarations' # OpenSSL 3.0 deprecation warnings
$CFLAGS << ' -Wno-undef'                   # Undefined macros in fastpbkdf2.c
$CFLAGS << ' -Wno-c2x-extensions'          # Ruby 3.3+ C2x attribute warnings
$CFLAGS << ' -Wno-strict-prototypes'       # Ruby 3.3+ ANYARGS deprecation warnings

# Check for optional OpenMP support
# Note: macOS clang doesn't support -fopenmp flag
if RUBY_PLATFORM !~ /darwin/ && (have_library('gomp') || have_library('omp'))
  $CFLAGS << ' -fopenmp -DWITH_OPENMP'
  $LDFLAGS << ' -fopenmp'
end

# Create the Makefile
create_makefile('fastpbkdf2/fastpbkdf2')
