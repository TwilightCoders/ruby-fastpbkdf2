[![Gem Version](https://badge.fury.io/rb/ruby-fastpbkdf2.svg)](https://badge.fury.io/rb/ruby-fastpbkdf2)
[![CI](https://github.com/twilightcoders/ruby-fastpbkdf2/actions/workflows/ci.yml/badge.svg)](https://github.com/twilightcoders/ruby-fastpbkdf2/actions/workflows/ci.yml)
[![Maintainability](https://qlty.sh/badges/a5da0a90-9df5-4b9f-8e91-51079bfbc455/maintainability.svg)](https://qlty.sh/gh/TwilightCoders/projects/ruby-fastpbkdf2)
[![Test Coverage](https://qlty.sh/badges/a5da0a90-9df5-4b9f-8e91-51079bfbc455/test_coverage.svg)](https://qlty.sh/gh/TwilightCoders/projects/ruby-fastpbkdf2/metrics/code?sort=coverageRating)
![GitHub License](https://img.shields.io/github/license/twilightcoders/ruby-fastpbkdf2)

# ruby-fastpbkdf2

A Ruby gem providing high-performance PBKDF2 key derivation through Ruby bindings for the [fastpbkdf2](https://github.com/ctz/fastpbkdf2) C library. Delivers **1.5x faster** performance than Ruby's built-in OpenSSL PBKDF2 implementation.

## Quick Start

```bash
gem install ruby-fastpbkdf2
```

```ruby
require 'fastpbkdf2'

# Short method names (recommended)
key = FastPBKDF2.sha256('password', 'salt', 100000, 32)

# Full method names
key = FastPBKDF2.pbkdf2_hmac_sha256('password', 'salt', 100000, 32)

# Generic method with algorithm selection
key = FastPBKDF2.pbkdf2_hmac('sha256', 'password', 'salt', 100000, 32)
```

## Features

- **High Performance**: 1.5x faster than Ruby's OpenSSL PBKDF2
- **Multiple Algorithms**: SHA1, SHA256, and SHA512 support
- **Clean API**: Both short (`sha256`) and descriptive (`pbkdf2_hmac_sha256`) method names
- **Cross-Platform**: Compiles on macOS, Linux, and Windows
- **Drop-in Replacement**: Compatible with existing PBKDF2 workflows
- **Comprehensive Tests**: 94% test coverage with performance benchmarks

## Performance

Real-world benchmarks on macOS (x86_64) show consistent performance improvements across all scenarios:

### Low Security (1,000 iterations)

| Algorithm | FastPBKDF2 | OpenSSL | Speedup   | Use Case                 |
| --------- | ---------- | ------- | --------- | ------------------------ |
| SHA1      | 0.12ms     | 0.21ms  | **1.75x** | Basic web authentication |
| SHA256    | 0.23ms     | 0.35ms  | **1.52x** | Basic web authentication |
| SHA512    | 0.33ms     | 0.46ms  | **1.39x** | Basic web authentication |

### Medium Security (10,000 iterations)

| Algorithm | FastPBKDF2 | OpenSSL | Speedup   | Use Case              |
| --------- | ---------- | ------- | --------- | -------------------- |
| SHA1      | 1.19ms     | 2.09ms  | **1.76x** | File encryption keys |
| SHA256    | 2.35ms     | 3.44ms  | **1.46x** | File encryption keys |
| SHA512    | 3.29ms     | 4.60ms  | **1.40x** | File encryption keys |

### High Security (100,000 iterations)

| Algorithm | FastPBKDF2 | OpenSSL | Speedup   | Use Case              |
| --------- | ---------- | ------- | --------- | --------------------- |
| SHA1      | 11.87ms    | 20.96ms | **1.77x** | iOS backup encryption |
| SHA256 | 23.25ms | 34.26ms | **1.47x** | iOS backup encryption |
| SHA512 | 32.78ms | 45.79ms | **1.40x** | iOS backup encryption |

### Maximum Security (1,000,000 iterations)

| Algorithm | FastPBKDF2 | OpenSSL  | Speedup   | Use Case                   |
| --------- | ---------- | -------- | --------- | -------------------------- |
| SHA1      | 118.79ms   | 209.42ms | **1.76x** | Maximum security scenarios |
| SHA256    | 233.13ms   | 342.83ms | **1.47x** | Maximum security scenarios |
| SHA512    | 329.52ms   | 459.69ms | **1.40x** | Maximum security scenarios |

_Benchmarks run on macOS (x86_64), Ruby 3.3.5, averaged across 3 runs each. Results may vary by platform and hardware._

## API Reference

### Short Method Names (Recommended)

```ruby
# SHA1 (outputs 20 bytes by default)
key = FastPBKDF2.sha1(password, salt, iterations, length)

# SHA256 (outputs 32 bytes by default)
key = FastPBKDF2.sha256(password, salt, iterations, length)

# SHA512 (outputs 64 bytes by default)
key = FastPBKDF2.sha512(password, salt, iterations, length)
```

### Descriptive Method Names

```ruby
key = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, length)
key = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)
key = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations, length)
```

### Generic Method

```ruby
# Algorithm can be string or symbol, case insensitive
key = FastPBKDF2.pbkdf2_hmac('sha256', password, salt, iterations)      # Uses default length
key = FastPBKDF2.pbkdf2_hmac(:SHA256, password, salt, iterations, 16)   # Custom length
```

### Parameters

- **password**: String or binary password data
- **salt**: String or binary salt data
- **iterations**: Integer number of iterations (must be > 0)
- **length**: Integer output key length in bytes (must be > 0)

All methods return a binary string (ASCII-8BIT encoding) containing the derived key.

## Use Cases

### iOS Backup Decryption

Original motivation - enables fast iOS backup key derivation in Ruby:

```ruby
# High iteration count for iOS backup security
backup_key = FastPBKDF2.sha256(user_password, backup_salt, 100_000, 32)
```

### Password Hashing

```ruby
# Web application password derivation
salt = SecureRandom.random_bytes(32)
password_hash = FastPBKDF2.sha256(user_password, salt, 10_000, 32)
```

### Cryptographic Key Derivation

```ruby
# File encryption key from password
encryption_key = FastPBKDF2.sha256(passphrase, file_salt, 50_000, 32)
```

## Installation

### From RubyGems

```bash
gem install ruby-fastpbkdf2
```

### From Source

```bash
git clone https://github.com/twilightcoders/ruby-fastpbkdf2.git
cd ruby-fastpbkdf2
bundle install
rake compile
rake spec
gem build fastpbkdf2.gemspec
gem install ruby-fastpbkdf2-0.0.2.gem
```

### Requirements

- Ruby 2.7 or higher
- C compiler (GCC, Clang, or MSVC)
- OpenSSL development headers (libssl-dev on Ubuntu, openssl on macOS)

The gem compiles the fastpbkdf2 C library during installation, so no external dependencies are required at runtime.

## Cross-Platform Compatibility

This gem is designed to compile and run across major platforms:

### ✅ Supported Platforms

- **macOS**: Intel (x86_64) and Apple Silicon (arm64)
- **Linux**: x86_64, arm64, i686 (most distributions)
- **Windows**: x64, x86 (with DevKit or Visual Studio)

- **Unix variants**: FreeBSD, OpenBSD, NetBSD (with compatible toolchain)
### Platform-Specific Features

- **OpenMP Support**: Automatically enabled on Linux for parallel processing (disabled on macOS due to clang limitations)
- **SIMD Optimizations**: The underlying fastpbkdf2 C library includes architecture-specific optimizations
- **Compiler Detection**: Automatically adapts compilation flags for GCC, Clang, and MSVC

### Build Requirements by Platform
#### macOS
```bash

# Xcode Command Line Tools (includes clang and OpenSSL)
xcode-select --install
```
#### Linux (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install build-essential libssl-dev ruby-dev
```

```bash
sudo yum install gcc openssl-devel ruby-devel make
# OR on newer systems:

sudo dnf install gcc openssl-devel ruby-devel make

```
#### Windows

```bash
# Using RubyInstaller with DevKit
# Ensure you have the DevKit installed, then:
gem install ruby-fastpbkdf2
```

#### FreeBSD/OpenBSD/NetBSD

```bash
# Install required packages (exact commands vary by OS)
# Generally need: gcc or clang, openssl, ruby-dev equivalent
```

The gem's `extconf.rb` automatically detects the platform and adjusts compilation settings accordingly.

## Development

### Setup

```bash
git clone https://github.com/twilightcoders/ruby-fastpbkdf2.git
cd ruby-fastpbkdf2
bundle install
```

### Building

```bash
rake compile          # Compile C extension
rake clean && rake compile  # Clean rebuild
```

### Testing

```bash
rake spec              # Run test suite
rspec --format documentation  # Detailed test output
```

### Code Quality

```bash
qlty check             # Run code quality checks
rubocop                # Ruby style checking
```

### Benchmarking

Performance benchmarks are integrated into the test suite:

```bash
rspec spec/performance_spec.rb --format documentation
```

## Architecture

### C Extension

The gem uses Ruby's native extension API to wrap the fastpbkdf2 C library:

- **C Functions**: Direct bindings to `fastpbkdf2_hmac_sha1/256/512`
- **Method Aliases**: C-level aliases provide short method names (`sha1`, `sha256`, `sha512`)
- **Error Handling**: Proper Ruby exception raising for invalid inputs
- **Memory Management**: Safe handling of binary data between C and Ruby

### Ruby Wrapper

The Ruby layer provides convenience methods and maintains API compatibility:

- **Generic Interface**: Algorithm selection via string/symbol
- **Default Lengths**: Sensible defaults for each hash algorithm
- **Input Validation**: Ruby-level parameter checking
- **Compatibility**: Backward-compatible constant aliasing

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes with tests
4. Ensure tests pass (`rake spec`)
5. Check code quality (`qlty check`)
6. Commit your changes (`git commit -am 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.

The bundled fastpbkdf2 C library is in the public domain (CC0).

## Acknowledgments

- **fastpbkdf2**: Original C library by Joseph Birr-Pixton
- **python-fastpbkdf2**: Python bindings inspiration by Terry Chia (Ayrx)
- **Ruby Core**: Excellent C extension API and documentation

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and changes.

---

**Note**: This gem was developed to solve PBKDF2 performance bottlenecks in iOS backup decryption for the [imessage_utils](https://github.com/twilightcoders/imessage_utils) project.
