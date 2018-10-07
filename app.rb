require 'sinatra'
require 'sinatra/activerecord'
require "sinatra/reloader" if development?
require './models/url'
require './models/stat'

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
  url = Url.find_by(shortcode: params['splat'])
  if url.nil?
      halt 404, {message: 'shortcode is not exists'}.to_json
  else
    stats_response_for url
  end
end

get '/*' do
  url = Url.find_by(shortcode: params['splat'])
  if url.nil?
      halt 404, {message: 'The shortcode cannot be found in the system :-)'}.to_json
  else
    url.stats.create
    redirect to("#{url.url}"), 301
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

  def stats_response_for url
    response = Hash.new
    count = url.stats.count
    response[:startDate] = url.created_at.iso8601(3)
    response[:lastSeenDate] = url.stats.last.created_at.iso8601(3) unless count == 0
    response[:redirectCoun] = count
    response.to_json
  end

  def json_params
    begin
      response = JSON.parse(request.body.read)
      raise if response["url"].nil?  || !contains_legal_chars(response)  || !valid_url?(response)
      response
    rescue
        halt 400, {message: 'Invalid JSON'}.to_json
    end
  end

  def contains_legal_chars response
    /^([!#$&-;=?-_a-z~\[\]]|%[0-9a-fA-F]{2})+$/.match(response.values.join)
  end

  def valid_url? response
    uri = URI.parse(response["url"])
    %w( http https ).include?(uri.scheme)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
  end

end

