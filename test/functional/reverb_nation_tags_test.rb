require File.dirname(__FILE__) + '/../test_helper'

class ReverbNationTagsTest < Test::Unit::TestCase
  test_helper :render
  
  context 'On a page' do
    include ::ReverbNation::Test::Feeds
    
    before :each do
      @page = Page.new(:slug => 'test')
      ReverbNation::Artist.stub! :feed_base, :return => test_feed_base
    end

    describe 'a reverbnation tag' do
      it 'raises an error if no id is given' do
        assert_render_error /no id/i, '<r:reverbnation />'
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
              "<r:reverbnation id='tincat'><r:#{tag} /></r:reverbnation>"
          else
            assert_renders value,
              "<r:reverbnation id='tincat'><r:#{tag} /></r:reverbnation>"
          end
        end
      end
    end

    describe "a reverbnation:location tag" do
      it "renders the artist's location" do
        assert_renders 'San Jose, CA, US',
          "<r:reverbnation id='tincat'><r:location /></r:reverbnation>"
      end

      it "omits the artist's default country when rendering location" do
        assert_renders 'San Jose, CA',
          "<r:reverbnation id='tincat' country='US'>" +
          "<r:location />" +
          "</r:reverbnation>"
      end
    end

    describe "a reverbnation:shows:link tag" do
      it "renders a URL for show listings" do
        assert_renders(
          "http://www.reverbnation.com/tincat/?current_active_tab=show_bills",
          "<r:reverbnation id='tincat'><r:shows:link /></r:reverbnation>"
        )
      end
    end

    describe "a reverbnation:shows:each tag" do
      it "renders its content once for each show" do
        assert_renders "Blue Rock Shoot\nWine Affairs\n",
        [
          "<r:reverbnation id='tincat'><r:shows:each>",
          "<r:venue/>\n",
          "</r:shows:each></r:reverbnation>"
        ].join
      end
    end

    describe "a reverbnation:shows:each tag with a limit attribute" do
      it "limits the number of shows rendered" do
        assert_renders "Blue Rock Shoot\n",
        [
          "<r:reverbnation id='tincat'><r:shows:each limit='1'>",
          "<r:venue/>\n",
          "</r:shows:each></r:reverbnation>"
        ].join
      end
    end
    
    # I'm sure there's a library method that would do this for me.
    def attrs_to_s(attrs)
      (attrs || {}).map do |key, value|
        "#{key}='#{value.to_xs}'"
      end.join(' ')
    end
    
    def tags_for_shows(tag, options = {})
      attrs = attrs_to_s options[:attrs]
      show_attrs = attrs_to_s options[:show_attrs]
      [
        "<r:reverbnation id='tincat' #{attrs}>",
        "<r:shows:each><r:#{tag} #{show_attrs}/>\n</r:shows:each>",
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
      def default_country
        {:attrs => {:country => 'US'}}
      end
      
      describe "a reverbnation:shows:each:location tag" do
        it "omits the default country" do
          value = "Saratoga, CA\nSan Jose, SJ CR\n"
          assert_renders value, tags_for_shows('location', default_country)
        end
      end

      describe "a reverbnation:shows:each:address tag" do
        it "omits the default country" do
          value = [
            "14523 Big Basin Way, Saratoga, CA, 95070\n" +
            "1435 The Alameda, San Jose, SJ, CR\n" # made-up address
          ].join
          assert_renders value, tags_for_shows('address', default_country)
        end
      end
    end
    
    describe "a reverbnation:shows:each:date tag" do
      it "accepts a custom format" do
        assert_renders("2008-11-15\n2008-12-03\n",
          tags_for_shows('date', :show_attrs => {:custom => '%Y-%m-%d'})
        )
      end
    end
    
    describe "a reverbnation:shows:each:time tag" do
      it "accepts a custom format" do
        assert_renders("19\n19\n",
          tags_for_shows('time', :show_attrs => {:custom => '%k'})
        )
      end
    end
  end
  
  # TODO: display other artists playing at each show
  # TODO: limit number of shows to display
end
