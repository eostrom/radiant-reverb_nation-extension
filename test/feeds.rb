module ReverbNation
  module Test
    module Feeds
      def test_feed; <<END_FEED_CONTENTS; end
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" media="screen" href="http://www.reverbnation.com/rss_flash_reader/artist/rss2html.xsl"?>
<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:georss="http://www.georss.org/georss">
  <channel>
    <title>Show Schedule for Tin Cat</title>
    <artist_name>Tin Cat</artist_name>
    <genres>Folk / Rock / Power Folk</genres>
    <location>San Jose, CA, US</location>

    <band_members>Erik Ostrom, Dave Allender, Tom Gewecke: voices, guitars, bass, accordion, mandolin, piano, ukulele, percussion</band_members>
    <label>Unsigned</label>
    <link>http://www.reverbnation.com/tincat</link>
    <pubDate>Sun, 16 Nov 2008 00:30:00 GMT</pubDate>
    <description>Powered by ReverbNation.com</description>
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
      <tickets_url>http://brownpapertickets.com/</tickets_url>
    </item>
    <item>
      <title>Wed Dec 03 08  07:30 PM</title>

      <link>http://www.reverbnation.com/tincat</link>
      <description>Wine Affairs in San Jose, CA - </description>
      <pubDate>Mon, 03 Nov 2008 18:55:12 GMT</pubDate>
      <show_price>free (but buy some wine)</show_price>
      <author>ReverbNation</author>
      <loc>San Jose, CA US</loc>

      <venue>Wine Affairs</venue>
      <address>1435 The Alameda, San Jose, CA, 95126, US</address>
      <latitude>37.3332558</latitude>
      <longitude>-121.9144745</longitude>
      <georss:point>37.3332558 -121.9144745</georss:point>
      <note></note>

      <artist>
        <description>Tin Cat (Folk / Rock / Power Folk)</description>
        <artist>Tin Cat</artist>
        <genre>Folk / Rock / Power Folk</genre>
      </artist>
      <ticket_price>free (but buy some wine)</ticket_price>
      <tickets_url></tickets_url>

    </item>
  </channel>
</rss>
END_FEED_CONTENTS
    end
  end
end
