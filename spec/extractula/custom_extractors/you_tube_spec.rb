require File.dirname(__FILE__) + '/../../spec_helper'

describe Extractula::YouTube do
  before do
    @url = Domainatrix.parse("http://www.youtube.com/watch?v=FzRH3iTQPrk")
    @html = Nokogiri::HTML::Document.new
  end
  
  it "can extract videos from youtube.com" do
    Extractula::YouTube.can_extract?(@url, @html).should be_true
  end
  
  it "should have media type 'video'" do
    Extractula::YouTube.media_type.should == 'video'
  end
end

describe "extracting from a YouTube page" do
  
  before do
    @response = Extractula::OEmbed::Response.new(read_test_file("youtube-oembed.json"))
    Extractula::OEmbed.stub!(:request).and_return(@response)
    @extracted_content = Extractula::YouTube.new("http://www.youtube.com/watch?v=FzRH3iTQPrk", read_test_file("youtube.html")).extract
  end

  it "extracts the title" do
    @extracted_content.title.should == "The Sneezing Baby Panda"
  end

  it "extracts the content" do
    @extracted_content.content.should == "A Baby Panda SneezingOriginal footage taken and being used with kind permission of LJM Productions Pty. Ltd.,/Wild Candy Pty. Ltd. Authentic t-shirts http://www.sneezingbabypanda.com*The link in the video is at the request of the original owner of the footage. Do NOT ask for your link to be added as I will not respond. Thank you."
  end

  it "extracts the main video" do
    @extracted_content.video_embed.should == "\u003ciframe width=\"459\" height=\"344\" src=\"http:\/\/www.youtube.com\/embed\/FzRH3iTQPrk?fs=1\u0026feature=oembed\" frameborder=\"0\" allowfullscreen\u003e\u003c\/iframe\u003e"
  end

end