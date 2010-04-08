
Gem::Specification.new do |s|
  s.name              = "romdoc"
  s.version           = "0.1.0"
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "A TomDoc library for Ruby."
  s.homepage          = "http://github.com/defunkt/romdoc"
  s.email             = "chris@ozmm.org"
  s.authors           = [ "Chris Wanstrath" ]
  s.has_rdoc          = false

  s.files             = %w( README.md Rakefile LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")
  s.files            += Dir.glob("man/**/*")
  s.files            += Dir.glob("test/**/*")

  s.executables       = %w( romdoc )
  s.description       = <<desc
  TomDoc is a flexible code documentation with human readers in
  mind. romdoc is a Ruby library to discover and display TomDoc'd
  methods and classes.

  Given a Ruby file with TomDoc'd methods, romdoc can generate HTML or
  print to the console. You can use it to query up a single method or
  a group of methods, and it's usable from irb.

  If you're using TomDoc, romdoc is for you.
desc
end
