require 'open-uri'
require 'nokogiri'

class ReverbNation::Artist
  def initialize(options = {})
    @id = options[:id]
    @xml = options[:xml]
  end
  
  def name; field('artist_name') || field('artist'); end
  def genres; (field('genres') || field('genre') || '').split(' / '); end
  def location; field('location'); end
  def members; field('band_members'); end
  def label; field('label'); end
  def link; field('link'); end
  def branding; field('description'); end
  
  def shows
    xml.xpath('item').map do |item|
      ReverbNation::Show.new(:item => item)
    end
  end
  
protected
  
  def field(name)
    node = xml.xpath(name).first
    node.inner_html if node
  end
  
  SHOWS_FEED = "http://reverbnation.com/controller/rss/artist_shows_rss/"
  
  def feed
    raise ArgumentError if !@id
    @feed ||= open(SHOWS_FEED + @id) {|f| f.read}
  end
  
  def xml
    @xml ||= Nokogiri::XML(feed).xpath('//channel')
  end
end
