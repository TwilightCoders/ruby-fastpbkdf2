# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.1] - 2025-07-25

### Added

- Initial release of ruby-fastpbkdf2 gem
- Ruby C extension bindings for fastpbkdf2 C library
- Support for PBKDF2-HMAC-SHA1, SHA256, and SHA512 algorithms
- Short method aliases: `FastPBKDF2.sha1`, `FastPBKDF2.sha256`, `FastPBKDF2.sha512`
- Descriptive method names: `FastPBKDF2.pbkdf2_hmac_sha1`, etc.
- Generic interface: `FastPBKDF2.pbkdf2_hmac(algorithm, ...)`
- Comprehensive test suite with 94% coverage (50 tests)
- Performance benchmarks showing 1.47x speedup over OpenSSL
- Cross-platform compilation support (macOS, Linux, Windows)
- CI/CD pipeline with GitHub Actions
- Code quality tooling with qlty and RuboCop
- Memory leak prevention and proper C/Ruby memory management
- Full input validation and error handling
- Compatible with Ruby 2.7+

### Performance

- 1.47x faster than Ruby's built-in OpenSSL PBKDF2 implementation
- Optimized for iOS backup key derivation scenarios
- Efficient memory usage with proper cleanup

### Documentation

- Comprehensive README with usage examples
- API documentation with parameter descriptions
- Development setup and contribution guidelines
- Performance benchmarks and use cases

[Unreleased]: https://github.com/twilightcoders/ruby-fastpbkdf2/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/twilightcoders/ruby-fastpbkdf2/releases/tag/v0.0.1
