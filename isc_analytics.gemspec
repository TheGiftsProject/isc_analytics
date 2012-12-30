Gem::Specification.new do |s|
  s.name        = 'isc_analytics'
  s.authors     = ['Itay Adler', 'Yonatan Bergman']
  s.email       = %w(itayadler@gmail.com yonbergman@gmail.com)
  s.summary     = 'A simple Analytics Library'
  s.description = 'A simple client-side & server-side analytics library'
  s.files       = Dir['{app,lib,config,vendor}/**/*'] + %w(Rakefile Gemfile README.md)
  s.version     = '0.5.2'
  s.homepage    = 'https://github.com/TheGiftsProject/isc_analytics'

  s.add_dependency 'controller_support'
  s.add_dependency 'configreader'
  s.add_dependency 'activesupport'
end