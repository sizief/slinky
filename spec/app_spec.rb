require File.expand_path '../spec_helper.rb', __FILE__

context "GET to /all" do
  let(:response) { get "/all" }

  it "returns status 200 OK" do
    expect(response.status).to eq 200
  end
end

describe "POST to shorten" do
   
  context "with proper parameters" do
    let(:data){{shortcode: @random_shortcode, url: "http://alideishidi.com"}}
    let(:response) { post "/shorten", data.to_json, "CONTENT_TYPE" => "application/json" }
    
    it "return status code 201" do
      expect(response.status).to eq 201
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
    let(:data){{shortcode: "abcdex",url: "http://example.com"}}
    let(:first_response) { post "/shorten", data.to_json, "CONTENT_TYPE" => "application/json" }
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
