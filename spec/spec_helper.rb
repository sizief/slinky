require 'rack/test'
require_relative '../app'
require_relative '../models/url.rb'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |c|
  c.include RSpecMixin
  c.before(:example){@random_shortcode = Url.create_shortcode}
end
