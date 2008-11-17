require File.dirname(__FILE__) + '/../../test_helper'
require 'nokogiri'

class ReverbNation::ShowTest < Test::Unit::TestCase
  Show = ReverbNation::Show
  
  context 'A Show' do
    it 'requires an RSS item' do
      assert_raise ArgumentError do
        Show.new.venue
      end
    end
  end
  
  context 'A valid Show' do
    before :each do
      @show = Show.new(
        :item => Nokogiri::XML(FEED_CONTENTS).xpath('//item').first
      )
    end
    
    it 'has a link' do
      assert_equal 'http://www.reverbnation.com/tincat', @show.link
    end
    
    it 'has a ticket price' do
      assert_equal '$3', @show.ticket_price
    end

    it 'has a ticket link' do
      assert_equal 'http://tickets.com/', @show.ticket_link
    end
    
    it 'has a venue' do
      assert_equal 'Blue Rock Shoot', @show.venue
    end
    
    it 'has an address' do
      assert_equal '14523 Big Basin Way, Saratoga, CA, 95070, US', @show.address
    end
    
    it 'has a latitude' do
      assert_equal 37.2570076, @show.latitude
    end
    
    it 'has a longitude' do
      assert_equal -122.0343704, @show.longitude
    end
    
    it 'has a note' do
      assert_equal 'A note.', @show.note
    end
    
    it 'has artists' do
      ReverbNation::Artist.proxy! :new
      @show.artists
    end
    
  end
  
  
private

  FEED_CONTENTS = <<END_FEED_CONTENTS
<?xml version="1.0" encoding="UTF-8"?>
  <channel>
    <item>
      <title>Sat Nov 15 08  07:30 PM</title>

      <link>http://www.reverbnation.com/tincat</link>
      <description>Blue Rock Shoot in Saratoga, CA - One of our favorite rooms to make music in, aside from Tom's mom's living room.</description>
      <pubDate>Mon, 03 Nov 2008 18:53:23 GMT</pubDate>
      <show_price>$3</show_price>
      <author>ReverbNation</author>
      <loc>Saratoga, CA US</loc>

      <venue>Blue Rock Shoot</venue>
      <address>14523 Big Basin Way, Saratoga, CA, 95070, US</address>
      <latitude>37.2570076</latitude>
      <longitude>-122.0343704</longitude>
      <georss:point>37.2570076 -122.0343704</georss:point>
      <note>A note.</note>

      <artist>
        <description>Tin Cat (Folk / Rock / Power Folk)</description>
        <artist>Tin Cat</artist>
        <genre>Folk / Rock / Power Folk</genre>
      </artist>
      <artist>
        <description>The Toes</description>

        <artist>The Toes</artist>
      </artist>
      <ticket_price>$3</ticket_price>
      <tickets_url>http://tickets.com/</tickets_url>
    </item>
  </channel>
</rss>
END_FEED_CONTENTS

end
