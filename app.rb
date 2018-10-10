require 'sinatra'
require 'sinatra/activerecord'
require "sinatra/reloader" if development?
require './models/url'
require './models/stat'
require './app_helper.rb'

set :bind, '0.0.0.0'

before do
  content_type 'application/json'
end

get '/all' do
    Url.all.to_json
end

post '/shorten' do
  requested_url = Url.new(json_params)
  requested_url.save
  url = status_of requested_url
  status url[:status]
  url[:message].to_json
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

