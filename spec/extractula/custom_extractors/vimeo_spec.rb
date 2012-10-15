# encoding: utf-8

require File.dirname(__FILE__) + '/../../spec_helper'

describe Extractula::Vimeo do
  before do
    @url = Domainatrix.parse("http://vimeo.com/8833777")
    @html = Nokogiri::HTML::Document.new
  end
  
  it "can extract videos from vimeo.com" do
    Extractula::Vimeo.can_extract?(@url, @html).should be_true
  end
  
  it "should have media type 'video'" do
    Extractula::Vimeo.media_type.should == 'video'
  end
end

describe "extracting from a Vimeo page" do
  
  before do
    @response = Extractula::OEmbed::Response.new(read_test_file("vimeo.json"))
    Extractula::OEmbed.stub!(:request).and_return(@response)
    @extracted_content = Extractula::Vimeo.new("https://vimeo.com/51374257", read_test_file("vimeo.html")).extract
  end

  it "extracts the title" do
    @extracted_content.title.should == "Block"
  end

  it "extracts the content" do
    @extracted_content.content.should == "Starring: Emmy Blotnick and Matt Koff\nMusic: The Glitch Mob \"We Can Make The World Stop\"\nMade in 5 hours for the CCC 24 hour film festival"
  end

  it "extracts the main video" do
    @extracted_content.video_embed.should == "<iframe src=\"http:\/\/player.vimeo.com\/video\/51374257?title=1&amp;byline=1&amp;portrait=1\" width=\"1280\" height=\"720\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen><\/iframe>"
  end

end