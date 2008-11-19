require File.dirname(__FILE__) + '/../../test_helper'
require 'nokogiri'

class ReverbNation::ShowTest < Test::Unit::TestCase
  include ::ReverbNation::Test::Feeds

  Show = ReverbNation::Show
  
  describe 'A Show' do
    it 'requires an RSS item' do
      assert_raise ArgumentError do
        Show.new.venue
      end
    end
  end
  
  describe 'A valid Show' do
    before :each do
      @show = Show.new(
        :item => Nokogiri::XML(test_feed).xpath('//item').first
      )
    end
    
    it 'has a link' do
      assert_equal 'http://www.reverbnation.com/tincat', @show.link
    end
    
    it 'has a ticket price' do
      assert_equal '$3', @show.ticket_price
    end

    it 'has a ticket link' do
      assert_equal 'http://brownpapertickets.com/', @show.ticket_link
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
end
