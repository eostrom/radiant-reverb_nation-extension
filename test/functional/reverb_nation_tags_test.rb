require File.dirname(__FILE__) + '/../test_helper'

# TODO: stop hitting the live server for test data

class ReverbNationTagsTest < Test::Unit::TestCase
  test_helper :render

  context 'reverbnation tag' do
    before :each do
      @page = Page.new(:slug => 'test')
    end
    
    it 'raises an error if no artist is given' do
      assert_render_error /no artist/i, '<r:reverbnation />'
    end
  end
  
  {
    'name' => 'Tin Cat',
    'genres' => 'Folk / Rock / Power Folk',
    'members' => /Erik Ostrom/,
    'label' => '',
    'link' => 'http://www.reverbnation.com/tincat'
  }.each do |tag, value|
    context "reverbnation:#{tag} tag" do
      it "renders the artist's #{tag}" do
        @page = Page.new(:slug => 'test')
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
  
  context "reverbnation:location tag" do
    it "renders the artist's location" do
      @page = Page.new(:slug => 'test')
      assert_renders 'San Jose, CA, US',
        "<r:reverbnation artist='tincat'><r:location /></r:reverbnation>"
    end
    
    it "omits the artist's default country when rendering location" do
      @page = Page.new(:slug => 'test')
      assert_renders 'San Jose, CA',
        "<r:reverbnation artist='tincat' country='US'>" +
        "<r:location />" +
        "</r:reverbnation>"
    end
  end
  
  context "reverbnation:shows:link tag" do
    it "renders a URL for show listings" do
      @page = Page.new(:slug => 'test')
      assert_renders(
        "http://www.reverbnation.com/tincat/?current_active_tab=show_bills",
        "<r:reverbnation artist='tincat'><r:shows:link /></r:reverbnation>"
      )
    end
  end
  
  # At the moment, we're testing against the live server, and so we don't
  # know what shows are going to be there.  The expected values in most of
  # these tests just serve to assert that the tags actually render.
  {
    'link' => /http:\/\/www.reverbnation.com\//,
    'date' => //,
    'time' => //,
    'ticket_price' => //,
    'ticket_link' => //,
    'venue' => //,
    'location' => //,
    'address' => //,
    'latitude' => //,
    'longitude' => //,
    'note' => //
  }.each do |tag, value|
    context "reverbnation:shows:each:#{tag} tag" do
      it "renders the show's #{tag}" do
        @page = Page.new(:slug => 'test')
        tags = [
          "<r:reverbnation artist='tincat'>",
          "<r:shows:each:#{tag} />",
          "</r:reverbnation>"
        ].join
        
        if value.is_a? Regexp
          assert_render_match value, tags
            
        else
          assert_renders value, tags
        end
      end
    end
  end
  
  # TODO: custom time/date formats
  # TODO: omit default country in location
  # TODO: artists
end
