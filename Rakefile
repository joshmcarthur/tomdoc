require 'rake/testtask'

def command?(command)
  system("type #{command} > /dev/null 2>&1")
end

#
# Manual
#

if command? :ronn
  desc "Build and display the manual."
  task :man => "man:build" do
    exec "man man/tomdoc.5"
  end

  desc "Build and display the manual in your browser."
  task "man:html" => "man:build" do
    sh "open man/tomdoc.5.html"
  end

  desc "Build the manual"
  task "man:build" do
    sh "ronn -br5 --organization=MOJOMBO --manual='TomDoc Manual' man/*.ronn"
  end
end


#
# Tests
#

task :default => :test

if command? :turn
  desc "Run tests"
  task :test do
    suffix = "-n #{ENV['TEST']}" if ENV['TEST']
    sh "turn -Ilib:. test/*.rb #{suffix}"
  end
else
  Rake::TestTask.new do |t|
    t.libs << 'lib'
    t.libs << '.'
    t.pattern = 'test/**/*_test.rb'
    t.verbose = false
  end
end


#
# Development
#

desc "Drop to irb."
task :console do
  exec "irb -I lib -rtomdoc"
end


#
# Gems
#

begin
  require 'tomdoc/version'
  require 'mg'
  MG.new("tomdoc.gemspec")

  desc "Push a new version to Gemcutter and publish docs."
  task :publish => "gem:publish" do
    require File.dirname(__FILE__) + '/lib/tomdoc/version'

    sh "git tag v#{TomDoc::VERSION}"
    sh "git push origin master --tags"
    sh "git clean -fd"
  end
rescue LoadError
  warn "mg not available."
  warn "Install it with: gem i mg"
end
