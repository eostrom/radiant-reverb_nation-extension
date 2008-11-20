require 'feed_tools'

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
    REXML::XPath.match(xml, 'item').map do |item|
      ReverbNation::Show.new(:item => item)
    end
  end
  
protected
  
  def field(name)
    node = REXML::XPath.first(xml, name)
    node.text if node
  end
  
  def self.feed_base
    "http://www.reverbnation.com/controller/rss/artist_shows_rss/"
  end
  
  def feed
    raise ArgumentError if !@id
    @feed ||= FeedTools::Feed.open(File.join(self.class.feed_base, @id))
  end
  
  def xml
    @xml ||= feed.find_node('//channel')
  end
end
