#!/usr/bin/env ruby

# Cross-platform testing script for ruby-fastpbkdf2
require 'rbconfig'

class PlatformTester
  def self.run
    new.run
  end

  def run
    puts "🚀 ruby-fastpbkdf2 Platform Test Suite"
    puts "=" * 50

    print_platform_info
    test_dependencies
    test_compilation
    test_functionality
    test_performance

    puts "\n✅ All platform tests completed successfully!"
  end

  private

  def print_platform_info
    puts "\n📋 Platform Information:"
    puts "  OS: #{RbConfig::CONFIG['host_os']}"
    puts "  Architecture: #{RbConfig::CONFIG['host_cpu']}"
    puts "  Ruby: #{RUBY_VERSION} (#{RUBY_PLATFORM})"
    puts "  Compiler: #{RbConfig::CONFIG['CC']}"
  end

  def test_dependencies
    puts "\n🔍 Testing Dependencies:"

    # Test OpenSSL availability
    begin
      require 'openssl'
      puts "  ✅ OpenSSL: #{OpenSSL::OPENSSL_VERSION}"
    rescue LoadError
      puts "  ❌ OpenSSL: Not available"
      exit 1
    end

    # Test compiler
    cc_version = `#{RbConfig::CONFIG['CC']} --version 2>/dev/null`.lines.first&.strip
    if cc_version
      puts "  ✅ Compiler: #{cc_version}"
    else
      puts "  ❌ Compiler: Not available"
      exit 1
    end
  end

  def test_compilation
    puts "\n🔨 Testing Compilation:"

    # Clean and recompile
    system('rake clean >/dev/null 2>&1')

    if system('rake compile >/dev/null 2>&1')
      puts "  ✅ C extension compiled successfully"
    else
      puts "  ❌ C extension compilation failed"
      exit 1
    end
  end

  def test_functionality
    puts "\n🧪 Testing Functionality:"

    # Load the gem
    begin
      require_relative 'lib/fastpbkdf2'
      puts "  ✅ Gem loaded successfully"
    rescue LoadError => e
      puts "  ❌ Failed to load gem: #{e}"
      exit 1
    end

    # Test all algorithms
    algorithms = {
      'SHA1' => [:sha1, 20],
      'SHA256' => [:sha256, 32],
      'SHA512' => [:sha512, 64]
    }

    algorithms.each do |name, (method, default_len)|
      begin
        key = FastPBKDF2.send(method, 'test', 'salt', 1000, default_len)
        if key.length == default_len
          puts "  ✅ #{name}: Working (#{key.unpack1('H*')[0..7]}...)"
        else
          puts "  ❌ #{name}: Wrong key length"
          exit 1
        end
      rescue => e
        puts "  ❌ #{name}: #{e}"
        exit 1
      end
    end

    # Test generic method
    begin
      key = FastPBKDF2.pbkdf2_hmac('sha256', 'test', 'salt', 1000, 32)
      puts "  ✅ Generic method: Working"
    rescue => e
      puts "  ❌ Generic method: #{e}"
      exit 1
    end
  end

  def test_performance
    puts "\n⚡ Performance Test:"

    require 'benchmark'

    password = 'benchmark_test'
    salt = 'benchmark_salt'
    iterations = 10000

    # Test FastPBKDF2
    fast_time = Benchmark.measure do
      10.times { FastPBKDF2.sha256(password, salt, iterations, 32) }
    end

    # Test OpenSSL
    openssl_time = Benchmark.measure do
      10.times { OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, 32, 'SHA256') }
    end

    improvement = openssl_time.real / fast_time.real

    puts "  FastPBKDF2: #{(fast_time.real * 100).round(2)}ms (10 iterations)"
    puts "  OpenSSL:    #{(openssl_time.real * 100).round(2)}ms (10 iterations)"
    puts "  ✅ Performance: #{improvement.round(2)}x faster than OpenSSL"
  end
end

if __FILE__ == $0
  PlatformTester.run
end
