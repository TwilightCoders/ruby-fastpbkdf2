# Coverage reporting
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
  coverage_dir 'coverage'

  # Generate both HTML and JSON for CI
  if ENV['CI']
    require 'simplecov_json_formatter'
    SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
                                                                      SimpleCov::Formatter::HTMLFormatter,
                                                                      SimpleCov::Formatter::JSONFormatter
                                                                    ])
  else
    SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  end
end

require_relative '../lib/fastpbkdf2'

# Compile the C extension if it doesn't exist
unless File.exist?('ext/fastpbkdf2/fastpbkdf2.bundle') || File.exist?('ext/fastpbkdf2/fastpbkdf2.so')
  puts "Compiling C extension for tests..."
  system('rake compile')
end

# Load the compiled extension
require_relative '../ext/fastpbkdf2/fastpbkdf2'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on Module and main
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Show more detailed output
  config.formatter = :documentation

  # Run specs in random order to surface order dependencies
  config.order = :random
  Kernel.srand config.seed
end
