require 'openssl'

RSpec.describe "FastPBKDF2 compatibility with OpenSSL" do
  describe "SHA1 compatibility" do
    it "produces identical output to OpenSSL for simple case" do
      password = "password"
      salt = "salt"
      iterations = 1
      length = 20

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA1.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end

    it "matches OpenSSL for complex inputs" do
      password = "very_long_password_with_special_chars_!@#$%^&*()"
      salt = "complex_salt_" + "x" * 100
      iterations = 4096
      length = 20

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA1.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end

    it "matches OpenSSL for binary data" do
      password = (0..255).map(&:chr).join
      salt = "\x00\x01\x02\x03\xff\xfe\xfd\xfc"
      iterations = 1000
      length = 20

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA1.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end
  end

  describe "SHA256 compatibility" do
    it "produces identical output to OpenSSL for simple case" do
      password = "password"
      salt = "salt"
      iterations = 1
      length = 32

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA256.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end

    it "matches OpenSSL for high iteration counts" do
      password = "testpass"
      salt = "testsalt"
      iterations = 100000 # High iteration count
      length = 32

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA256.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end

    it "matches OpenSSL for long output lengths" do
      password = "test"
      salt = "salt"
      iterations = 1000
      length = 100 # Longer than single hash output

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA256.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end

    it "matches OpenSSL for empty password" do
      password = ""
      salt = "salt"
      iterations = 1000
      length = 32

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA256.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end

    it "matches OpenSSL for empty salt" do
      password = "password"
      salt = ""
      iterations = 1000
      length = 32

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA256.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end
  end

  describe "SHA512 compatibility" do
    it "produces identical output to OpenSSL for simple case" do
      password = "password"
      salt = "salt"
      iterations = 1
      length = 64

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA512.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end

    it "matches OpenSSL for very long outputs" do
      password = "password"
      salt = "salt"
      iterations = 1000
      length = 1000 # Much longer than single SHA512 output

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA512.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end

    it "matches OpenSSL for short outputs" do
      password = "password"
      salt = "salt"
      iterations = 1000
      length = 10 # Much shorter than SHA512 output

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA512.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end
  end

  describe "real-world test vectors" do
    # Test vectors from RFC 6070 and other sources
    it "matches RFC 6070 test vector 1 (SHA1)" do
      password = "password"
      salt = "salt"
      iterations = 1
      length = 20
      expected = "\x0c\x60\xc8\x0f\x96\x1f\x0e\x71\xf3\xa9\xb5\x24\xaf\x60\x12\x06\x2f\xe0\x37\xa6".force_encoding('ASCII-8BIT')

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA1.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, length)

      expect(openssl_result).to eq(expected)
      expect(fastpbkdf2_result).to eq(expected)
      expect(fastpbkdf2_result).to eq(openssl_result)
    end

    it "matches RFC 6070 test vector 2 (SHA1)" do
      password = "password"
      salt = "salt"
      iterations = 2
      length = 20
      expected = "\xea\x6c\x01\x4d\xc7\x2d\x6f\x8c\xcd\x1e\xd9\x2a\xce\x1d\x41\xf0\xd8\xde\x89\x57".force_encoding('ASCII-8BIT')

      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA1.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, length)

      expect(openssl_result).to eq(expected)
      expect(fastpbkdf2_result).to eq(expected)
      expect(fastpbkdf2_result).to eq(openssl_result)
    end

    it "matches known SHA256 test vector" do
      password = "password"
      salt = "salt"
      iterations = 1
      length = 32

      # Use OpenSSL as our reference since it's the standard
      openssl_result = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, OpenSSL::Digest::SHA256.new)
      fastpbkdf2_result = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)

      expect(fastpbkdf2_result).to eq(openssl_result)
    end
  end
end
