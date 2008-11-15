require 'rss/2.0'
require 'open-uri'
require 'nokogiri'

module ReverbNationTags
  include Radiant::Taggable
  
  SHOWS_FEED = "http://reverbnation.com/controller/rss/artist_shows_rss/"

  tag 'reverbnation' do |tag|
    tag.locals.artist = tag.attr['artist']
    return 'No artist specified for ReverbNation' if tag.locals.artist.blank?
    tag.locals.feed = open(SHOWS_FEED + tag.locals.artist) {|f| f.read}
    tag.locals.xml = Nokogiri::XML(tag.locals.feed)
    
    tag.expand
  end
  
  {
    'artist' => 'artist_name',
    'genres' => 'genres',
    'location' => 'location',
    'members' => 'band_members',
    'label' => 'label',
    'link' => 'link',
    'brand' => 'description'
  }.each do |tagname, rssname|
    tag "reverbnation:#{tagname}" do |tag|
      # Won't work, RSS parser strips RN-specific data.
      tag.locals.xml.xpath("//channel/#{rssname}").first.inner_html
    end
  end
  
  tag 'reverbnation:shows' do |tag|
    tag.expand
  end
  
  tag 'reverbnation:shows:link' do |tag|
    "http://www.reverbnation.com/#{tag.locals.artist}/" +
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

    'price' => 'ticket_price',
    'tickets_link' => 'tickets_url',

    'venue' => 'venue',
    'address' => 'address',
    'latitude' => 'latitude',
    'longitude' => 'longitude',
    'georss:point' => 'georss:point',

    'note' => 'note'
  }.each do |tagname, rssname|
    tag "reverbnation:shows:each:#{tagname}" do |tag|
      tag.locals.item.xpath(rssname).first.inner_html
    end
  end
  
  tag "reverbnation:shows:each:location" do |tag|
    location = tag.locals.item.xpath('loc').first.inner_html
    country = tag.attr['country']
    if country
      location.sub!(/ #{country}$/, '').sub!(/, *$/, '')
    end
    location
  end
  
  Time::DATE_FORMATS[:show_date] = '%b %e'
  Time::DATE_FORMATS[:show_time] = '%I:%M %p'

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
