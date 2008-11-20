require 'rss/2.0'
require 'open-uri'
require 'nokogiri'

module ReverbNationTags
  include Radiant::Taggable
  
  SHOWS_FEED = "http://reverbnation.com/controller/rss/artist_shows_rss/"
  
  def shows_feed(artist_id)
    open(SHOWS_FEED + artist_id) {|f| f.read}
  end
  
  tag 'reverbnation' do |tag|
    tag.locals.artist_id = tag.attr['id']
    if tag.locals.artist_id.blank?
      raise ArgumentError, 'No id specified for ReverbNation'
    end
    tag.locals.country = tag.attr['country']
    tag.locals.feed = shows_feed(tag.locals.artist_id)
    tag.locals.xml = Nokogiri::XML(tag.locals.feed)
    
    tag.expand
  end
  
  {
    'name' => 'artist_name',
    'genres' => 'genres',
    'members' => 'band_members',
    'label' => 'label',
    'link' => 'link',
    'branding' => 'description'
  }.each do |tagname, rssname|
    tag "reverbnation:#{tagname}" do |tag|
      tag.locals.xml.xpath("//channel/#{rssname}").first.inner_html
    end
  end
  
  tag 'reverbnation:location' do |tag|
    location = tag.locals.xml.xpath("//channel/location").first.inner_html
    location.sub(/, #{tag.locals.country}$/, '')
  end
  
  tag 'reverbnation:shows' do |tag|
    tag.expand
  end
  
  tag 'reverbnation:shows:link' do |tag|
    "http://www.reverbnation.com/#{tag.locals.artist_id}/" +
      "?current_active_tab=show_bills"
  end
  
  tag 'reverbnation:shows:each' do |tag|
    tag.locals.xml.xpath('//item').map do |item|
      tag.locals.item = item
      tag.locals.date = Time.parse(item.xpath('title').first.inner_text)
      tag.expand
    end
  end
  
  {
    'link' => 'link', # currently useless - keep hope alive!

    'ticket_price' => 'ticket_price',
    'ticket_link' => 'tickets_url',

    'venue' => 'venue',
    'latitude' => 'latitude',
    'longitude' => 'longitude',
    'georss:point' => 'georss:point',

    'note' => 'note'
  }.each do |tagname, rssname|
    tag "reverbnation:shows:each:#{tagname}" do |tag|
      tag.locals.item.xpath(rssname).first.inner_html
    end
  end
  
  def omit_country(tag, element)
    value = tag.locals.item.xpath(element).first.inner_html
    country = tag.locals.country
    if country
      value.sub(/,? #{country}$/, '').sub(/, *$/, '')
    else
      value
    end
  end
  
  tag "reverbnation:shows:each:location" do |tag|
    omit_country(tag, 'loc')
  end
  
  tag "reverbnation:shows:each:address" do |tag|
    omit_country(tag, 'address')
  end
  
  Time::DATE_FORMATS[:show_date] = '%b %e'
  Time::DATE_FORMATS[:show_time] = '%l:%M %p'

  ['date', 'time'].each do |tagname, format|
    tag "reverbnation:shows:each:#{tagname}" do |tag|
      custom = tag.attr['custom']
      if custom
        tag.locals.date.strftime(custom)
      else
        tag.locals.date.to_s("show_#{tag.name}".to_sym)
      end
    end
  end
  
  # TODO: artists
end
