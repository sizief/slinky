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
      raise if response["url"].nil?  || !contains_legal_chars(response.values.join)  || !valid_url?(response)
      response.select{|key, value| ["url","shortcode"].include? key.to_s} #permit params
    rescue
        halt 400, {message: 'Invalid JSON'}.to_json
    end
  end

  def query_param param
    begin
      raise if !contains_legal_chars(param[0])
      param[0]
    rescue
        halt 400, {message: "#{param[0]} in url is not valid"}.to_json
    end
  end

  def contains_legal_chars response
    /^([!#$&-;=?-_a-z~\[\]]|%[0-9a-fA-F]{2})+$/.match(response) #check for non legal characters to import into url
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
