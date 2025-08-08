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

  # Hex variants for convenience (return lowercase hex string)
  def pbkdf2_hmac_hex(algorithm, password, salt, iterations, dklen = nil)
    pbkdf2_hmac(algorithm, password, salt, iterations, dklen).unpack1('H*')
  end

  def sha1_hex(password, salt, iterations, dklen = 20)
    sha1(password, salt, iterations, dklen).unpack1('H*')
  end

  def sha256_hex(password, salt, iterations, dklen = 32)
    sha256(password, salt, iterations, dklen).unpack1('H*')
  end

  def sha512_hex(password, salt, iterations, dklen = 64)
    sha512(password, salt, iterations, dklen).unpack1('H*')
  end

  # Constant-time comparison for derived keys (returns true/false)
  # Prefer this over == to avoid timing leaks when comparing secrets.
  # FastPBKDF2.secure_compare(a, b) is implemented in C.

  # Soft warning threshold for iterations (default set in C). Set to nil/0 to disable.
  # FastPBKDF2.iteration_warning_threshold = 2_000_000
end

# Create alias for backward compatibility (lowercase version)
Fastpbkdf2 = ::FastPBKDF2
