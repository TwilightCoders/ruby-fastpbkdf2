require 'mkmf'

# Configure OpenSSL paths for different platforms
if RUBY_PLATFORM =~ /darwin/
  # macOS: Check common Homebrew paths for OpenSSL
  openssl_paths = [
    '/opt/homebrew/opt/openssl@3',  # Apple Silicon Homebrew
    '/usr/local/opt/openssl@3',     # Intel Homebrew
    '/opt/homebrew/opt/openssl',    # Apple Silicon Homebrew (fallback)
    '/usr/local/opt/openssl'        # Intel Homebrew (fallback)
  ]

  openssl_found = false
  openssl_paths.each do |path|
    if Dir.exist?(path)
      dir_config('openssl', "#{path}/include", "#{path}/lib")
      openssl_found = true
      break
    end
  end

  unless openssl_found
    puts "Warning: OpenSSL not found in standard Homebrew locations"
    puts "Trying system paths..."
  end
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

# Use wrapper approach - compile fastpbkdf2_wrapper.c instead of copying files
# The wrapper handles platform compatibility without modifying vendor files
$objs = ['fastpbkdf2_wrapper.o', 'fastpbkdf2_ruby.o']

# Create the Makefile
create_makefile('fastpbkdf2/fastpbkdf2')
