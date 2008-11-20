require File.dirname(__FILE__) + '/../../test_helper'
require 'nokogiri'

class ReverbNation::ArtistTest < Test::Unit::TestCase
  include ::ReverbNation::Test::Feeds

  Artist = ReverbNation::Artist
  
  describe 'An Artist' do
    it 'requires an ID or an XML fragment to look up most data' do
      assert_raise ArgumentError do
        Artist.new.location
      end
    end
  end
  
  describe 'An Artist with an ID' do
    before :each do
      @artist = Artist.new(:id => 'tincat')
      Artist.stub! :feed, :return => test_feed
    end
    
    it 'has a name' do
      assert_equal 'Tin Cat', @artist.name
    end
    
    it 'may have genres' do
      assert_equal ['Folk', 'Rock', 'Power Folk'], @artist.genres
    end
    
    it 'has a location' do
      assert_equal 'San Jose, CA, US', @artist.location
    end
    
    it 'has members' do
      assert_equal 'Erik Ostrom, Dave Allender, Tom Gewecke: voices, guitars, bass, accordion, mandolin, piano, ukulele, percussion', @artist.members
    end
    
    it 'has a label' do
      assert_equal 'Unsigned', @artist.label
    end
    
    it 'has a link' do
      assert_equal 'http://www.reverbnation.com/tincat', @artist.link
    end
    
    it 'has branding' do
      assert_equal 'Powered by ReverbNation.com', @artist.branding
    end
    
    it 'has shows' do
      ReverbNation::Show.proxy! :new
      @artist.shows
    end
  end

  describe 'An Artist with an XML fragment' do
    before :each do
      @artist = Artist.new(
        :xml => Nokogiri::XML(test_feed).xpath('//artist')[2]
      )
    end
    
    it 'has a name' do
      assert_equal 'The Toes', @artist.name
    end
    
    it 'may have genres' do
      @artist = Artist.new(
        :xml => Nokogiri::XML(test_feed).xpath('//artist')[0]
      )
      assert_equal ['Folk', 'Rock', 'Power Folk'], @artist.genres
    end
    
    it 'may not have genres' do
      assert_equal [], @artist.genres
    end
    
  end
end
