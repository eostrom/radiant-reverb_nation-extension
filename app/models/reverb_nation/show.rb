require 'nokogiri'

class ReverbNation::Show
  def initialize(options = {})
    @item = options[:item] || (raise ArgumentError)
  end
  
  def datetime; DateTime.parse(field('title'), true); end
  def link; field('link'); end
  def ticket_price; field('ticket_price'); end
  def ticket_link; field('tickets_url'); end
  def venue; field('venue'); end
  def location; field('loc'); end
  def address; field('address'); end
  def latitude; field('latitude').to_f; end
  def longitude; field('longitude').to_f; end
  def note; field('note'); end
  
  def artists
    @item.xpath('artist').each do |xml|
      ReverbNation::Artist.new(:xml => xml)
    end
  end
  
protected
  
  def field(name)
    @item.xpath(name).first.inner_html
  end
end
