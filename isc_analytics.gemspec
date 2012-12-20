# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "isc_analytics"
  s.summary = "A simple Analytics Library"
  s.description = "A simple client-side & server-side analytics library"
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = '0.5'

  s.add_dependency 'controller_support'
  s.add_dependency 'configreader'
  s.add_dependency 'activesupport'
end