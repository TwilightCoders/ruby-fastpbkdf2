require_relative 'fastpbkdf2/version'

# Load the C extension first which defines FastPBKDF2
require 'fastpbkdf2/fastpbkdf2'

# Ensure FastPBKDF2 is available at top level
unless defined?(::FastPBKDF2)
  raise LoadError, "FastPBKDF2 C extension did not load properly"
end

# Add shorter aliases using class << syntax
class << FastPBKDF2
  def pbkdf2_hmac(algorithm, password, salt, iterations, dklen = nil)
    case algorithm.to_s.downcase
    when 'sha1'
      dklen ||= 20
      sha1(password, salt, iterations, dklen)
    when 'sha256'
      dklen ||= 32
      sha256(password, salt, iterations, dklen)
    when 'sha512'
      dklen ||= 64
      sha512(password, salt, iterations, dklen)
    else
      raise ArgumentError, "Unsupported algorithm: #{algorithm}"
    end
  end
end

# Create alias for backward compatibility (lowercase version)
Fastpbkdf2 = ::FastPBKDF2
