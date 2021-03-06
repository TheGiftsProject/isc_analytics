# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../.dummy/config/environment.rb",  __FILE__)


# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  config.include RSpec::Matchers

  # == Mock Framework
  config.mock_with :rspec
end