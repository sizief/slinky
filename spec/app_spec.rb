require File.expand_path '../spec_helper.rb', __FILE__

context "GET to /all" do
  let(:response) { get "/all" }

  it "returns status 200 OK" do
    expect(response.status).to eq 200
  end
end

describe "POST to shorten" do
   
  context "with all parameters available" do
    let(:data){{shortcode: @random_shortcode, url: "http://alideishidi.com"}}
    let(:response) { post "/shorten", data.to_json, "CONTENT_TYPE" => "application/json" }
    
    it "return status code 201" do
      expect(response.status).to eq(201), "failed with #{data}"
    end
  end

  context "with url only available" do
    let(:data){{url: "http://alideishidi.com"}}
    let(:response) { post "/shorten", data.to_json, "CONTENT_TYPE" => "application/json" }
    
    it "return status code 201" do
      expect(response.status).to eq(201), "failed with #{data}"
    end
  end

  context "without json" do
    let(:response) { post "/shorten"}

    it "return status code 400" do
      expect(response.status).to eq 400
    end
  end

  context "without url" do
    let(:data){{shortcode: "xyzbvc"}}
    let(:response) { post "/shorten", data.to_json, "CONTENT_TYPE" => "application/json" }

    it "return status code 400" do
      expect(response.status).to eq 400
    end
  end

  context "with duplicate shortcode" do
    before do
      Url.create(url: "http://alideishidi.com")
      @exist_shortcode = Url.last.shortcode
    end

    let(:data){{shortcode: @exist_shortcode, url: "http://example.com"}}
    let(:second_response) { post "/shorten", data.to_json, "CONTENT_TYPE" => "application/json" }
    it "return 409 for second request" do
      expect(second_response.status).to eq 409
    end
  end

  context "not satisfied our conditions: less than 6 charcters" do
    let(:data){{shortcode: "abcde", url: "http://example.com"}}
    let(:response) { post "/shorten", data.to_json, "CONTENT_TYPE" => "application/json" }

    it "return status code 422" do
      expect(response.status).to eq 422
    end
  end

  context "not satisfied our conditions: contain illegal chars" do
    let(:data){{shortcode: "12345%", url: "http://example.com"}}
    let(:response) { post "/shorten", data.to_json, "CONTENT_TYPE" => "application/json" }

    it "return status code 422" do
      expect(response.status).to eq 422
    end
  end
end

describe "GET to receive url" do
  before do
    @get_url = Url.create(url: "alideishidi.com")
  end
  
  context "shortcode is exists" do
    let(:response) { get "/#{@get_url.shortcode}"}
    
    it "return status code 301" do
      expect(response.status).to eq(301), "failed with #{@get_url.shortcode}"
    end
  end

  context "shortcode is not exists" do
    let(:response) { get "/40dozd"}
    
    it "return status code 301" do
      expect(response.status).to eq 404
    end
  end 
end


describe "GET to receive stats" do
  before do
    @get_url = Url.create(url: "alideishidi.com")
  end
  
  context "when shortcode is exists" do
    let(:response) { get "/#{@get_url.shortcode}/stats"}
    
    it "return status code 200" do
      expect(response.status).to eq 200
    end
  end

  context "when shortcode is not exists" do
    let(:response) { get "/40dozd/stats"}
    
    it "return status code 301" do
      expect(response.status).to eq 404
    end
  end 
end

describe "Send illegal charcter in url" do
  context "for POST inside url param" do
    let(:invalid_url){{url: "alideishidi.com<>"}}
    let(:response) { post "/shorten", invalid_url.to_json, "CONTENT_TYPE" => "application/json" }
  
    it "return status code 400" do
      expect(response.status).to eq 400
    end
  end
  
  context "for POST inside shortcode" do
    let(:invalid_url){{url: "alideishidi.com", shortcode: "asdf<>"}}
    let(:response) { post "/shorten", invalid_url.to_json, "CONTENT_TYPE" => "application/json" }
  
    it "return status code 400" do
      expect(response.status).to eq 400
    end
  end
  
end
