require 'sinatra'
require 'sinatra/activerecord'
require "sinatra/reloader" if development?
require './models/url'
#require 'sinatra/activerecord/rake'

#set :environment, :test
#set :RACK_ENV, :production
#set :server, :puma
set :bind, '0.0.0.0'

before do
  content_type 'application/json'
end

get '/all' do
    Url.all.to_json
end

post '/shorten' do
  url = Url.new(json_params)
  if url.save
    status 201
    {shortcode: url.shortcode}.to_json
  else
    status 422
  end
end

helpers do
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
  end

  def json_params
    begin
      JSON.parse(request.body.read)
    rescue
      halt 400, { message:'Invalid JSON' }.to_json
    end
  end
end

