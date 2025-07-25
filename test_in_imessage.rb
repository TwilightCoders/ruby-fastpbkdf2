#!/usr/bin/env ruby

# Test script to verify fastpbkdf2 works in imessage_utils context
require 'fastpbkdf2'

# Test our gem functions
puts "=== FastPBKDF2 Ruby Gem Test ==="

# Test basic functionality
password = 'test_password'
salt = 'test_salt'
iterations = 100000
key_length = 32

puts "Testing with:"
puts "  Password: '#{password}'"
puts "  Salt: '#{salt}'"
puts "  Iterations: #{iterations}"
puts "  Key length: #{key_length} bytes"
puts

# Test SHA256 (most common in iOS backups)
start_time = Time.now
key_sha256 = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, key_length)
duration_sha256 = Time.now - start_time

puts "SHA256 Result:"
puts "  Key (hex): #{key_sha256.unpack1('H*')}"
puts "  Duration: #{(duration_sha256 * 1000).round(3)}ms"
puts

# Test SHA1 (also used in iOS backups)
start_time = Time.now
key_sha1 = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, 20)
duration_sha1 = Time.now - start_time

puts "SHA1 Result:"
puts "  Key (hex): #{key_sha1.unpack1('H*')}"
puts "  Duration: #{(duration_sha1 * 1000).round(3)}ms"
puts

# Test compatibility with OpenSSL
require 'openssl'
start_time = Time.now
openssl_key = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, key_length, 'SHA256')
duration_openssl = Time.now - start_time

puts "OpenSSL SHA256 for comparison:"
puts "  Key (hex): #{openssl_key.unpack1('H*')}"
puts "  Duration: #{(duration_openssl * 1000).round(3)}ms"
puts "  Match: #{key_sha256 == openssl_key ? '✅ YES' : '❌ NO'}"
puts

performance_improvement = duration_openssl / duration_sha256
puts "Performance improvement: #{performance_improvement.round(2)}x faster than OpenSSL"

puts "\n=== Test Complete ==="
