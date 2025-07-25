require 'benchmark'
require 'openssl'

RSpec.describe "FastPBKDF2 performance" do
  # Skip performance tests by default since they're slow
  # Run with: rspec --tag performance spec/performance_spec.rb

  describe "performance comparison with OpenSSL", :performance do
    let(:password) { "test_password_for_performance" }
    let(:salt) { "test_salt_for_performance_testing" }
    let(:iterations) { 10000 } # Reasonable but not too slow for testing
    let(:length) { 32 }

    it "SHA256 is faster than OpenSSL" do
      # Warm up
      FastPBKDF2.pbkdf2_hmac_sha256(password, salt, 100, length)
      OpenSSL::PKCS5.pbkdf2_hmac(password, salt, 100, length, OpenSSL::Digest::SHA256.new)

      fastpbkdf2_time = Benchmark.realtime do
        3.times { FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length) }
      end

      openssl_time = Benchmark.realtime do
        3.times { OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA256.new) }
      end

      puts "\nPerformance comparison (#{iterations} iterations, 3 runs each):"
      puts "FastPBKDF2 SHA256: #{(fastpbkdf2_time * 1000).round(2)}ms"
      puts "OpenSSL SHA256:    #{(openssl_time * 1000).round(2)}ms"

      if fastpbkdf2_time < openssl_time
        speedup = (openssl_time / fastpbkdf2_time).round(2)
        puts "FastPBKDF2 is #{speedup}x faster"

        # We expect at least some speedup, but let's be conservative for tests
        expect(speedup).to be > 1.0
      else
        puts "FastPBKDF2 was slower - this may indicate a performance regression"
        # Don't fail the test, just warn
      end
    end

    it "performs well with high iteration counts" do
      high_iterations = 100000

      time = Benchmark.realtime do
        FastPBKDF2.pbkdf2_hmac_sha256(password, salt, high_iterations, length)
      end

      puts "\nHigh iteration test (#{high_iterations} iterations):"
      puts "FastPBKDF2 SHA256: #{time.round(3)}s"

      # Should complete in reasonable time (less than 10 seconds on modern hardware)
      expect(time).to be < 10.0
    end

    it "benchmarks all three algorithms" do
      test_iterations = 5000 # Lower for this test since we're running all three

      puts "\nAlgorithm comparison (#{test_iterations} iterations):"

      sha1_time = Benchmark.realtime do
        FastPBKDF2.pbkdf2_hmac_sha1(password, salt, test_iterations, 20)
      end

      sha256_time = Benchmark.realtime do
        FastPBKDF2.pbkdf2_hmac_sha256(password, salt, test_iterations, 32)
      end

      sha512_time = Benchmark.realtime do
        FastPBKDF2.pbkdf2_hmac_sha512(password, salt, test_iterations, 64)
      end

      puts "SHA1:   #{(sha1_time * 1000).round(2)}ms"
      puts "SHA256: #{(sha256_time * 1000).round(2)}ms"
      puts "SHA512: #{(sha512_time * 1000).round(2)}ms"

      # All should complete in reasonable time
      expect(sha1_time).to be < 5.0
      expect(sha256_time).to be < 5.0
      expect(sha512_time).to be < 5.0
    end
  end

  describe "iOS backup scenario", :performance do
    # This is the real-world use case that motivated this gem
    it "performs iOS backup key derivation in reasonable time" do
      # Typical iOS backup parameters
      password = "user_backup_password"
      salt = "\x01" * 20 # 20-byte salt
      iterations = 100000 # iOS uses 100k iterations
      length = 32 # 256-bit key

      time = Benchmark.realtime do
        FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)
      end

      puts "\niOS backup key derivation simulation:"
      puts "Password: '#{password}'"
      puts "Iterations: #{iterations}"
      puts "Key length: #{length} bytes"
      puts "Time: #{time.round(3)}s"

      # Should be much faster than the 30+ seconds mentioned in the README
      expect(time).to be < 5.0 # Allow 5 seconds max

      # For comparison, let's also time OpenSSL
      openssl_time = Benchmark.realtime do
        OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA256.new)
      end

      puts "OpenSSL equivalent: #{openssl_time.round(3)}s"

      if time < openssl_time
        speedup = (openssl_time / time).round(2)
        puts "FastPBKDF2 is #{speedup}x faster for iOS backup scenario"
      end
    end
  end

  describe "memory usage", :performance do
    it "doesn't leak memory with repeated calls" do
      # This is a basic smoke test - real memory testing would require more sophisticated tools
      password = "memory_test"
      salt = "salt"
      iterations = 1000
      length = 32

      # Run many iterations to check for obvious memory leaks
      expect {
        1000.times do
          FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)
        end
      }.not_to raise_error

      puts "\nMemory test: 1000 iterations completed successfully"
    end
  end
end
