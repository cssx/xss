$:.unshift File.dirname(__FILE__) + '/../lib'
require 'xss'

require 'support/parser_helper'
require 'support/serializer_helper'

N = XSS::Nodes
V = XSS::Values

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
