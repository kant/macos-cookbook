require 'chefspec'
require 'chefspec/berkshelf'
require_relative '../libraries/xcode_helpers'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
end
