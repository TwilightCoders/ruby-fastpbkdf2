# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- (Planned) Hex-encoded helpers: `sha1_hex`, `sha256_hex`, `sha512_hex`, and generic `pbkdf2_hmac_hex`
- (Planned) Optional warning hook for very large iteration counts

### Changed
- (Planned) README: document upstream submodule verification steps

### Security
- (Planned) Guidance for choosing iteration counts and salt sizes

## [0.0.2] - 2025-08-08

### Added
- Argument validation hardening in C extension (iteration and dklen bounds)
- Derived key length safety cap (256MB) to avoid pathological allocation
- RubyGems MFA metadata (`rubygems_mfa_required = true`)

### Fixed
- Rake `upstream_status` path now matches actual `vendor/fastpbkdf2`
- README installation example updated to current version

### Internal
- Unified integer coercion via `rb_to_int` and `NUM2ULONG`
- Consistent error messaging across algorithms

### Documentation
- Clarified validation semantics and internal comments

### Integrity
- Noted upstream submodule commit: `3c568957 (v1.0.0-8-g3c56895)`

### Notes
- No public API changes; backward compatible

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

[Unreleased]: https://github.com/twilightcoders/ruby-fastpbkdf2/compare/v0.0.2...HEAD
[0.0.2]: https://github.com/twilightcoders/ruby-fastpbkdf2/releases/tag/v0.0.2
[0.0.1]: https://github.com/twilightcoders/ruby-fastpbkdf2/releases/tag/v0.0.1
