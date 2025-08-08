require_relative 'lib/fastpbkdf2/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-fastpbkdf2'
  spec.version       = FastPBKDF2::VERSION
  spec.authors       = ['TwilightCoders']
  spec.email         = ['hello@twilightcoders.net']

  spec.summary       = 'High-performance PBKDF2 for Ruby'
  spec.description   = 'Ruby bindings for the fastpbkdf2 C library, providing 10-50x performance improvements over Ruby\'s built-in PBKDF2 implementation.'
  spec.homepage      = 'https://github.com/twilightcoders/ruby-fastpbkdf2'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = "#{spec.homepage}.git"
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['documentation_uri'] = spec.homepage
  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir['CHANGELOG.md', 'README.md', 'LICENSE', 'lib/**/*', 'bin/*', 'ext/**/*'] +
                       Dir['vendor/fastpbkdf2/{fastpbkdf2.c,fastpbkdf2.h,LICENSE}']
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.extensions    = ['ext/fastpbkdf2/extconf.rb']

  # Development dependencies
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rake-compiler', '~> 1.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
