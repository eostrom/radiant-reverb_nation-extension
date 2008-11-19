require File.dirname(__FILE__) + '/../test_helper'

class ReverbNationTagsTest < Test::Unit::TestCase
  test_helper :render
  
  context 'On a page' do
    include ::ReverbNation::Test::Feeds
    
    before :each do
      @page = Page.new(:slug => 'test')
      @page.stub! :shows_feed, :return => test_feed
    end

    describe 'a reverbnation tag' do
      it 'raises an error if no artist is given' do
        assert_render_error /no artist/i, '<r:reverbnation />'
      end
    end

    {
      'name' => 'Tin Cat',
      'genres' => 'Folk / Rock / Power Folk',
      'members' => /Erik Ostrom/,
      'label' => 'Unsigned',
      'link' => 'http://www.reverbnation.com/tincat'
    }.each do |tag, value|
      describe "a reverbnation:#{tag} tag" do
        it "renders the artist's #{tag}" do
          if value.is_a? Regexp
            assert_render_match value,
              "<r:reverbnation artist='tincat'><r:#{tag} /></r:reverbnation>"
          else
            assert_renders value,
              "<r:reverbnation artist='tincat'><r:#{tag} /></r:reverbnation>"
          end
        end
      end
    end

    describe "a reverbnation:location tag" do
      it "renders the artist's location" do
        assert_renders 'San Jose, CA, US',
          "<r:reverbnation artist='tincat'><r:location /></r:reverbnation>"
      end

      it "omits the artist's default country when rendering location" do
        assert_renders 'San Jose, CA',
          "<r:reverbnation artist='tincat' country='US'>" +
          "<r:location />" +
          "</r:reverbnation>"
      end
    end

    describe "a reverbnation:shows:link tag" do
      it "renders a URL for show listings" do
        assert_renders(
          "http://www.reverbnation.com/tincat/?current_active_tab=show_bills",
          "<r:reverbnation artist='tincat'><r:shows:link /></r:reverbnation>"
        )
      end
    end

    def tags_for_shows(tag, country = nil)
      country_attr = "country='#{country}'" if country
      [
        "<r:reverbnation artist='tincat' #{country_attr}>",
        "<r:shows:each><r:#{tag} />\n</r:shows:each>",
        "</r:reverbnation>"
      ].join
    end
    
    {
      'link' => "http://www.reverbnation.com/tincat\n" * 2,
      'date' => "Nov 15\nDec  3\n",
      'time' => " 7:30 PM\n 7:30 PM\n",
      'ticket_price' => "$3\nfree\n",
      'ticket_link' => "http://brownpapertickets.com/\n\n",
      'venue' => "Blue Rock Shoot\nWine Affairs\n",
      'location' => "Saratoga, CA US\nSan Jose, SJ CR\n",
      'address' => [
        "14523 Big Basin Way, Saratoga, CA, 95070, US\n" +
        "1435 The Alameda, San Jose, SJ, CR\n" # made-up address
      ].join,
      'latitude' => "37.2570076\n37.3332558\n",
      'longitude' => "-122.0343704\n-121.9144745\n",
      'note' => "A note.\n\n"
    }.each do |tag, value|
      describe "a reverbnation:shows:each:#{tag} tag" do
        it "renders the show's #{tag}" do
          if value.is_a? Regexp
            assert_render_match value, tags_for_shows(tag)

          else
            assert_renders value, tags_for_shows(tag)
          end
        end
      end
    end

    context "given a default country" do
      describe "a reverbnation:shows:each:location tag" do
        it "omits the default country" do
          value = "Saratoga, CA\nSan Jose, SJ CR\n"
          assert_renders value, tags_for_shows('location', 'US')
        end
      end

      describe "a reverbnation:shows:each:address tag" do
        it "omits the default country" do
          value = [
            "14523 Big Basin Way, Saratoga, CA, 95070\n" +
            "1435 The Alameda, San Jose, SJ, CR\n" # made-up address
          ].join
          assert_renders value, tags_for_shows('address', 'US')
        end
      end
    end
  end
  
  # TODO: custom time/date formats
  # TODO: artists
end
