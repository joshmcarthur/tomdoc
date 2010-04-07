
Gem::Specification.new do |s|
  s.name              = "tomdoc-generator"
  s.version           = "0.1.0"
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Feed me."
  s.homepage          = "http://github.com/defunkt/tomdoc-generator"
  s.email             = "chris@ozmm.org"
  s.authors           = [ "Chris Wanstrath" ]
  s.has_rdoc          = false

  s.files             = %w( README.md Rakefile LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")
  s.files            += Dir.glob("man/**/*")
  s.files            += Dir.glob("test/**/*")

#  s.executables       = %w( tomdoc-generator )
  s.description       = <<desc
  Feed me.
desc
end
