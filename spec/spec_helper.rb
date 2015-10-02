$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'cmap'

require File.expand_path("./support/helpers.rb", File.dirname(__FILE__))

RSpec.configure do |c|
  c.include Helpers
end
