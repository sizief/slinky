require File.expand_path '../spec_helper.rb', __FILE__

describe "when user requests /shorten get url " do
  it "should return all urls" do
    get '/all'
    expect(last_response).to be_ok
  end
end
