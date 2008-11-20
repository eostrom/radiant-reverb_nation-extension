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
  
  def self.feed(url) # we use a class method for ease of stubbing
    open(url) #{|f| f.read}
  end
  
  SHOWS_FEED = "http://reverbnation.com/controller/rss/artist_shows_rss/"
  
  def feed
    raise ArgumentError if !@id
    @feed ||= self.class.feed(SHOWS_FEED + @id)
  end
  
  def xml
    @xml ||= Nokogiri::XML(feed).xpath('//channel')
  end
end
