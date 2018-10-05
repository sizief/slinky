require 'rack/test'
#require 'rspec'
require_relative '../app'

ENV['RACK_ENV'] = 'test'

#require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |c|
  c.include RSpecMixin
  c.before(:example){@random_shortcode = [*'0'..'9', *'a'..'z','A'..'Z',"_"].sample(6).join.to_s}
end
