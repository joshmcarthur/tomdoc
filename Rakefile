require 'rake/testtask'

def command?(command)
  system("type #{command} > /dev/null")
end


#
# Tests
#

task :default => :test

if command? :turn
  desc "Run tests"
  task :test do
    suffix = "-n #{ENV['TEST']}" if ENV['TEST']
    sh "turn test/*.rb #{suffix}"
  end
else
  Rake::TestTask.new do |t|
    t.libs << 'lib'
    t.pattern = 'test/**/*_test.rb'
    t.verbose = false
  end
end


#
# Gems
#

begin
  require 'mg'
  MG.new("tomdoc-generator.gemspec")

  desc "Build a gem."
  task :gem => :package

  # Ensure tests pass before pushing a gem.
  task :gemcutter => :test

  desc "Push a new version to Gemcutter and publish docs."
  task :publish => :gemcutter do
    require File.dirname(__FILE__) + '/lib/tomdoc-generator/version'

    system "git tag v#{TomDoc::VERSION}"
    sh "git push origin master --tags"
    sh "git clean -fd"
  end
rescue LoadError
  warn "mg not available."
  warn "Install it with: gem i mg"
end
