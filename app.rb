require 'sinatra'
require 'sinatra/activerecord'
require "sinatra/reloader" if development?
require './models/url'
require './models/stat'
require './app_helper.rb'

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
  url.save
  
  case status_of url
    when 201   
      status 201
      {shortcode: url.shortcode}.to_json
    when 409
      status 409
      {message: "shortcode already taken, try again without sending shortcode, we will pick one for you :-)"}.to_json
    when 422
      status 422
      {message: "The shortcode should contains only A-Z or 0-9 and underline, and it should be six characters."}.to_json
    else
      status 404  
  end
end

get '/*/stats' do
  url = Url.find_by(shortcode: query_param(params['splat']))
  if url.nil?
      halt 404, {message: 'shortcode is not exists'}.to_json
  else
    stats_response_for url
  end
end

get '/*' do
  param = query_param(params['splat'])
  url = Url.find_by(shortcode: param)
  if url.nil?
    halt 404, {message: "#{param}:  The shortcode cannot be found in the system :-)"}.to_json
  else
    url.stats.create
    redirect to("#{url.url}"), 301
  end
end
