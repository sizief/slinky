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

helpers do
  def status_of url
    if url.errors.messages.empty?
      return 201
    elsif url.errors.messages.values.first.first == "not_unique"
      return 409
    elsif url.errors.messages.values.first.first == "condition_failed"
      return 422
    end
  end

  #def base_url
  #  @base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
  #end

  def json_params
    begin
      response = JSON.parse(request.body.read)
      raise if response["url"].nil? 
      response
    rescue
      halt 400, { message:'Invalid JSON' }.to_json
    end
  end
end

