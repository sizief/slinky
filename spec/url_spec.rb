require File.expand_path '../spec_helper.rb', __FILE__

describe Url  do

  before do
    @shortcode = Url.create_shortcode
    @contains_illegal_chars = "!@#$%^&*()".chars.all? { |char| @shortcode.include?(char) }
  end

  let(:shortcode_size){@shortcode.size}
  it "should create correct shortcode" do
    expect(@contains_illegal_chars).to be false
    expect(shortcode_size).to eq(6)
  end
end


