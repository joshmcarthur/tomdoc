require 'rake/testtask'

def command(command)
  if system("type #{command} > /dev/null 2>&1")
    yield
  else
    warn "* Can't find #{command} in $PATH"
  end
end

command :ronn do
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
