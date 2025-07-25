require 'fileutils'

# Load gem specification
require_relative 'lib/fastpbkdf2/version'

task :default => :test

desc "Set up development environment"
task :setup do
  puts "Setting up fastpbkdf2-ruby development environment..."

  # Initialize submodules
  sh "git submodule update --init --recursive"

  # Sync upstream source
  Rake::Task['sync'].invoke

  # Compile extension
  Rake::Task['compile'].invoke

  puts "✅ Development environment ready!"
end

desc "Sync upstream fastpbkdf2 source to ext/ directory"
task :sync do
  upstream_dir = 'vendor/fastpbkdf2'
  ext_dir = 'ext/fastpbkdf2'

  unless Dir.exist?(upstream_dir) && File.exist?("#{upstream_dir}/fastpbkdf2.c")
    puts "❌ Upstream submodule not found or empty. Run: rake setup"
    exit 1
  end

  # Update submodule to latest
  puts "🔄 Updating upstream submodule..."
  sh "cd #{upstream_dir} && git pull origin master"

  # Copy source files
  puts "📋 Copying latest C source files..."
  FileUtils.cp("#{upstream_dir}/fastpbkdf2.c", ext_dir)
  FileUtils.cp("#{upstream_dir}/fastpbkdf2.h", ext_dir)

  puts "✅ Upstream source synced!"
end

desc "Compile the C extension"
task :compile do
  Dir.chdir('ext/fastpbkdf2') do
    ruby 'extconf.rb'
    sh 'make clean'
    sh 'make'
  end

  # Copy compiled extension to lib directory
  FileUtils.mkdir_p('lib/fastpbkdf2')
  compiled_ext = Dir.glob('ext/fastpbkdf2/fastpbkdf2.{bundle,so}').first
  if compiled_ext
    FileUtils.cp(compiled_ext, 'lib/fastpbkdf2/')
    puts "✅ Extension compiled and copied to lib/!"
  else
    puts "❌ Could not find compiled extension!"
    exit 1
  end
end

desc "Clean compiled files"
task :clean do
  Dir.chdir('ext/fastpbkdf2') do
    sh 'make clean' if File.exist?('Makefile')
    FileUtils.rm_f(Dir.glob('*.{o,bundle,so}'))
  end
  puts "✅ Cleaned compiled files!"
end

desc "Run tests"
task :test => :compile do
  sh "bundle exec rspec"
end

desc "Run tests including performance benchmarks"
task :test_performance => :compile do
  sh "bundle exec rspec --tag performance"
end

desc "Run all tests including performance"
task :test_all => :compile do
  sh "bundle exec rspec --tag performance --tag ~performance"
end

desc "Show upstream status"
task :upstream_status do
  puts "📊 Upstream fastpbkdf2 status:"
  sh "cd vendor/fastpbkdf2-upstream && git log --oneline -5"

  puts "\n📋 Current vendored files:"
  %w[fastpbkdf2.c fastpbkdf2.h].each do |file|
    if File.exist?("ext/fastpbkdf2/#{file}")
      mtime = File.mtime("ext/fastpbkdf2/#{file}")
      puts "  #{file}: #{mtime.strftime('%Y-%m-%d %H:%M:%S')}"
    else
      puts "  #{file}: ❌ MISSING"
    end
  end
end
