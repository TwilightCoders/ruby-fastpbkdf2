#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'fastpbkdf2'
require 'openssl'
require 'benchmark'

def run_benchmarks
  puts "# Performance Benchmarks"
  puts
  puts "Platform: #{RUBY_PLATFORM}"
  puts "Ruby Version: #{RUBY_VERSION}"
  puts "FastPBKDF2 Version: #{FastPBKDF2::VERSION}"
  puts

  # Test parameters
  password = "benchmark_password"
  salt = "benchmark_salt_16bytes"

  # Different iteration counts for different use cases
  scenarios = [
    { name: "Low Security (Web Auth)", iterations: 1_000, desc: "Basic web authentication" },
    { name: "Medium Security (File Encryption)", iterations: 10_000, desc: "File encryption keys" },
    { name: "High Security (iOS Backup)", iterations: 100_000, desc: "iOS backup encryption" },
    { name: "Maximum Security (Paranoid)", iterations: 1_000_000, desc: "Maximum security scenarios" }
  ]

  algorithms = [
    { name: "SHA1", fast_method: :sha1, openssl_digest: "sha1", key_length: 20 },
    { name: "SHA256", fast_method: :sha256, openssl_digest: "sha256", key_length: 32 },
    { name: "SHA512", fast_method: :sha512, openssl_digest: "sha512", key_length: 64 }
  ]

  puts "## Benchmark Results"
  puts

  scenarios.each do |scenario|
    puts "### #{scenario[:name]} (#{scenario[:iterations].to_s.reverse.gsub(/(\d{3})(?=\d)/,
                                                                            '\\1,').reverse} iterations)"
    puts
    puts "| Algorithm | FastPBKDF2 | OpenSSL | Speedup | Use Case |"
    puts "|-----------|------------|---------|---------|----------|"

    algorithms.each do |algo|
      # Warm up
      FastPBKDF2.send(algo[:fast_method], password, salt, 100, algo[:key_length])
      OpenSSL::PKCS5.pbkdf2_hmac(password, salt, 100, algo[:key_length], algo[:openssl_digest])

      # Benchmark FastPBKDF2
      fast_time = Benchmark.realtime do
        3.times { FastPBKDF2.send(algo[:fast_method], password, salt, scenario[:iterations], algo[:key_length]) }
      end
      fast_avg = (fast_time / 3.0 * 1000).round(2) # Convert to milliseconds

      # Benchmark OpenSSL
      openssl_time = Benchmark.realtime do
        3.times {
          OpenSSL::PKCS5.pbkdf2_hmac(password, salt, scenario[:iterations], algo[:key_length], algo[:openssl_digest])
        }
      end
      openssl_avg = (openssl_time / 3.0 * 1000).round(2) # Convert to milliseconds

      speedup = (openssl_avg / fast_avg).round(2)

      # Format times appropriately
      if fast_avg >= 1000
        fast_str = "#{(fast_avg / 1000).round(2)}s"
        openssl_str = "#{(openssl_avg / 1000).round(2)}s"
      else
        fast_str = "#{fast_avg}ms"
        openssl_str = "#{openssl_avg}ms"
      end

      puts "| #{algo[:name]} | #{fast_str} | #{openssl_str} | #{speedup}x | #{scenario[:desc]} |"
    end

    puts
  end

  # Memory usage test
  puts "## Memory Usage"
  puts
  puts "Memory usage test (1000 iterations of SHA256 with 100k iterations each):"

  # Get initial memory
  initial_memory = `ps -o rss= -p #{Process.pid}`.to_i

  # Run test
  1000.times do |i|
    FastPBKDF2.sha256("test#{i}", "salt#{i}", 100_000, 32)
    print "." if i % 100 == 0
  end
  puts

  # Get final memory
  final_memory = `ps -o rss= -p #{Process.pid}`.to_i
  memory_diff = final_memory - initial_memory

  puts "- Initial memory: #{initial_memory} KB"
  puts "- Final memory: #{final_memory} KB"
  puts "- Memory difference: #{memory_diff} KB (#{memory_diff > 0 ? '+' : ''}#{memory_diff})"
  puts "- Result: #{memory_diff.abs < 1000 ? '✅ No significant memory leak detected' : '⚠️ Potential memory usage increase'}"
  puts

  puts "## Test Environment"
  puts
  puts "- **Platform**: #{RUBY_PLATFORM}"
  puts "- **Ruby Version**: #{RUBY_VERSION}"
  puts "- **Architecture**: #{RbConfig::CONFIG['host_cpu']}"
  puts "- **Compiler**: #{RbConfig::CONFIG['CC']}"
  puts "- **OS**: #{RbConfig::CONFIG['host_os']}"
  puts
  puts "*Note: Benchmarks run with 3 iterations each, averaged. Results may vary based on hardware and system load.*"
end

if __FILE__ == $0
  puts "Running FastPBKDF2 Benchmarks..."
  puts "=" * 50
  puts
  run_benchmarks
end
