RSpec.describe FastPBKDF2 do
  describe "module methods" do
    it "responds to all three PBKDF2 methods" do
      expect(FastPBKDF2).to respond_to(:pbkdf2_hmac_sha1)
      expect(FastPBKDF2).to respond_to(:pbkdf2_hmac_sha256)
      expect(FastPBKDF2).to respond_to(:pbkdf2_hmac_sha512)
    end

    it "responds to short method aliases" do
      expect(FastPBKDF2).to respond_to(:sha1)
      expect(FastPBKDF2).to respond_to(:sha256)
      expect(FastPBKDF2).to respond_to(:sha512)
    end

    it "responds to generic pbkdf2_hmac method" do
      expect(FastPBKDF2).to respond_to(:pbkdf2_hmac)
    end
  end

  describe "short method aliases" do
    describe ".sha1" do
      it "produces identical output to pbkdf2_hmac_sha1" do
        password = "test_password"
        salt = "test_salt"
        iterations = 1000
        length = 20

        long_result = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, length)
        short_result = FastPBKDF2.sha1(password, salt, iterations, length)

        expect(short_result).to eq(long_result)
      end
    end

    describe ".sha256" do
      it "produces identical output to pbkdf2_hmac_sha256" do
        password = "test_password"
        salt = "test_salt"
        iterations = 1000
        length = 32

        long_result = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)
        short_result = FastPBKDF2.sha256(password, salt, iterations, length)

        expect(short_result).to eq(long_result)
      end
    end

    describe ".sha512" do
      it "produces identical output to pbkdf2_hmac_sha512" do
        password = "test_password"
        salt = "test_salt"
        iterations = 1000
        length = 64

        long_result = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations, length)
        short_result = FastPBKDF2.sha512(password, salt, iterations, length)

        expect(short_result).to eq(long_result)
      end
    end
  end

  describe ".pbkdf2_hmac generic method" do
    it "supports sha1 algorithm" do
      password = "test_password"
      salt = "test_salt"
      iterations = 1000

      result = FastPBKDF2.pbkdf2_hmac('sha1', password, salt, iterations)
      expected = FastPBKDF2.sha1(password, salt, iterations, 20)

      expect(result).to eq(expected)
      expect(result.length).to eq(20)
    end

    it "supports sha256 algorithm" do
      password = "test_password"
      salt = "test_salt"
      iterations = 1000

      result = FastPBKDF2.pbkdf2_hmac('sha256', password, salt, iterations)
      expected = FastPBKDF2.sha256(password, salt, iterations, 32)

      expect(result).to eq(expected)
      expect(result.length).to eq(32)
    end

    it "supports sha512 algorithm" do
      password = "test_password"
      salt = "test_salt"
      iterations = 1000

      result = FastPBKDF2.pbkdf2_hmac('sha512', password, salt, iterations)
      expected = FastPBKDF2.sha512(password, salt, iterations, 64)

      expect(result).to eq(expected)
      expect(result.length).to eq(64)
    end

    it "accepts custom output lengths" do
      password = "test_password"
      salt = "test_salt"
      iterations = 1000
      custom_length = 16

      result = FastPBKDF2.pbkdf2_hmac('sha256', password, salt, iterations, custom_length)
      expected = FastPBKDF2.sha256(password, salt, iterations, custom_length)

      expect(result).to eq(expected)
      expect(result.length).to eq(custom_length)
    end

    it "is case insensitive for algorithm names" do
      password = "test_password"
      salt = "test_salt"
      iterations = 1000

      result1 = FastPBKDF2.pbkdf2_hmac('SHA256', password, salt, iterations)
      result2 = FastPBKDF2.pbkdf2_hmac('sha256', password, salt, iterations)
      result3 = FastPBKDF2.pbkdf2_hmac(:sha256, password, salt, iterations)

      expect(result1).to eq(result2)
      expect(result2).to eq(result3)
    end

    it "raises error for unsupported algorithm" do
      expect {
        FastPBKDF2.pbkdf2_hmac('md5', 'password', 'salt', 1000)
      }.to raise_error(ArgumentError, /Unsupported algorithm: md5/)
    end
  end

  describe ".pbkdf2_hmac_sha1" do
    it "produces correct output for known test vector" do
      password = "password"
      salt = "salt"
      iterations = 1
      length = 20

      result = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, length)

      expect(result).to be_a(String)
      expect(result.length).to eq(length)
      expect(result.encoding).to eq(Encoding::ASCII_8BIT)
    end

    it "produces different outputs for different inputs" do
      password1 = "password1"
      password2 = "password2"
      salt = "salt"
      iterations = 1000
      length = 20

      result1 = FastPBKDF2.pbkdf2_hmac_sha1(password1, salt, iterations, length)
      result2 = FastPBKDF2.pbkdf2_hmac_sha1(password2, salt, iterations, length)

      expect(result1).not_to eq(result2)
    end

    it "handles binary input data" do
      password = "\x00\x01\x02\x03"
      salt = "\xff\xfe\xfd\xfc"
      iterations = 100
      length = 20

      expect { FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, length) }.not_to raise_error
    end

    it "raises error for zero iterations" do
      expect { FastPBKDF2.pbkdf2_hmac_sha1("password", "salt", 0, 20) }.to raise_error(ArgumentError, /iterations must be between 1 and \d+/)
    end

    it "raises error for zero length" do
      expect { FastPBKDF2.pbkdf2_hmac_sha1("password", "salt", 1000, 0) }.to raise_error(ArgumentError, /length must be greater than 0/)
    end

    it "raises error for non-string password" do
      expect { FastPBKDF2.pbkdf2_hmac_sha1(123, "salt", 1000, 20) }.to raise_error(TypeError)
    end

    it "raises error for non-string salt" do
      expect { FastPBKDF2.pbkdf2_hmac_sha1("password", 123, 1000, 20) }.to raise_error(TypeError)
    end

    it "raises error for non-integer iterations" do
      expect { FastPBKDF2.pbkdf2_hmac_sha1("password", "salt", "1000", 20) }.to raise_error(TypeError)
    end

    it "raises error for non-integer length" do
      expect { FastPBKDF2.pbkdf2_hmac_sha1("password", "salt", 1000, "20") }.to raise_error(TypeError)
    end
  end

  describe ".pbkdf2_hmac_sha256" do
    it "produces correct output for known test vector" do
      password = "password"
      salt = "salt"
      iterations = 1
      length = 32

      result = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)

      expect(result).to be_a(String)
      expect(result.length).to eq(length)
      expect(result.encoding).to eq(Encoding::ASCII_8BIT)
    end

    it "produces different outputs for different salts" do
      password = "password"
      salt1 = "salt1"
      salt2 = "salt2"
      iterations = 1000
      length = 32

      result1 = FastPBKDF2.pbkdf2_hmac_sha256(password, salt1, iterations, length)
      result2 = FastPBKDF2.pbkdf2_hmac_sha256(password, salt2, iterations, length)

      expect(result1).not_to eq(result2)
    end

    it "works with long outputs" do
      password = "password"
      salt = "salt"
      iterations = 100
      length = 1000 # Much longer than hash output

      result = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)
      expect(result.length).to eq(length)
    end

    it "error handling matches SHA1 version" do
      expect { FastPBKDF2.pbkdf2_hmac_sha256("password", "salt", 0, 32) }.to raise_error(ArgumentError)
      expect { FastPBKDF2.pbkdf2_hmac_sha256("password", "salt", 1000, 0) }.to raise_error(ArgumentError)
      expect { FastPBKDF2.pbkdf2_hmac_sha256(123, "salt", 1000, 32) }.to raise_error(TypeError)
    end
  end

  describe ".pbkdf2_hmac_sha512" do
    it "produces correct output for known test vector" do
      password = "password"
      salt = "salt"
      iterations = 1
      length = 64

      result = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations, length)

      expect(result).to be_a(String)
      expect(result.length).to eq(length)
      expect(result.encoding).to eq(Encoding::ASCII_8BIT)
    end

    it "produces different outputs for different iteration counts" do
      password = "password"
      salt = "salt"
      iterations1 = 1000
      iterations2 = 2000
      length = 64

      result1 = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations1, length)
      result2 = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations2, length)

      expect(result1).not_to eq(result2)
    end

    it "handles very small outputs" do
      password = "password"
      salt = "salt"
      iterations = 100
      length = 1 # Very small output

      result = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations, length)
      expect(result.length).to eq(length)
    end

    it "error handling matches other versions" do
      expect { FastPBKDF2.pbkdf2_hmac_sha512("password", "salt", 0, 64) }.to raise_error(ArgumentError)
      expect { FastPBKDF2.pbkdf2_hmac_sha512("password", "salt", 1000, 0) }.to raise_error(ArgumentError)
      expect { FastPBKDF2.pbkdf2_hmac_sha512(123, "salt", 1000, 64) }.to raise_error(TypeError)
    end
  end

  describe "cross-algorithm consistency" do
    it "different algorithms produce different outputs for same input" do
      password = "testpassword"
      salt = "testsalt"
      iterations = 1000
      length = 20 # Use length that all can produce

      sha1_result = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, length)
      sha256_result = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)
      sha512_result = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations, length)

      expect(sha1_result).not_to eq(sha256_result)
      expect(sha256_result).not_to eq(sha512_result)
      expect(sha1_result).not_to eq(sha512_result)
    end

    it "all algorithms are deterministic" do
      password = "consistent"
      salt = "test"
      iterations = 500
      length = 32

      # Run each algorithm twice
      sha1_1 = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, 20)
      sha1_2 = FastPBKDF2.pbkdf2_hmac_sha1(password, salt, iterations, 20)

      sha256_1 = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)
      sha256_2 = FastPBKDF2.pbkdf2_hmac_sha256(password, salt, iterations, length)

      sha512_1 = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations, length)
      sha512_2 = FastPBKDF2.pbkdf2_hmac_sha512(password, salt, iterations, length)

      expect(sha1_1).to eq(sha1_2)
      expect(sha256_1).to eq(sha256_2)
      expect(sha512_1).to eq(sha512_2)
    end
  end
end
