module ReverbNationTags
  include Radiant::Taggable
  
  tag 'reverbnation' do |tag|
    tag.locals.artist_id = tag.attr['id']
    if tag.locals.artist_id.blank?
      raise ArgumentError, 'No id specified for ReverbNation'
    end
    tag.locals.artist = ReverbNation::Artist.new(:id => tag.locals.artist_id)
    tag.locals.country = tag.attr['country']
    
    tag.expand
  end
  
  # TODO: remove link tag
  ['name', 'members', 'label', 'link', 'branding']. each do |tagname|
    tag "reverbnation:#{tagname}" do |tag|
      tag.locals.artist.send(tagname)
    end
  end
  
  tag "reverbnation:url" do |tag|
    tag.locals.artist.link
  end
  
  tag "reverbnation:genres" do |tag|
    tag.locals.artist.genres.join(' / ')
  end
  
  tag 'reverbnation:location' do |tag|
    tag.locals.artist.location.sub(/, #{tag.locals.country}$/, '')
  end
  
  tag 'reverbnation:shows' do |tag|
    tag.expand
  end
  
  tag 'reverbnation:shows:url' do |tag|
    "http://www.reverbnation.com/#{tag.locals.artist_id}/" +
      "?current_active_tab=show_bills"
  end
  
  # TODO: remove link tag
  tag 'reverbnation:shows:link' do |tag|
    "http://www.reverbnation.com/#{tag.locals.artist_id}/" +
      "?current_active_tab=show_bills"
  end
  
  tag 'reverbnation:shows:each' do |tag|
    tag.locals.artist.shows[0..(tag.attr['limit'] || 0).to_i - 1].map do |show|
      tag.locals.show = show
      tag.expand
    end
  end
  
  # TODO: remove link tag
  ['link', 'ticket_price', 'ticket_link',
    'venue', 'latitude', 'longitude', 'note'
  ].each do |tagname|
    tag "reverbnation:shows:each:#{tagname}" do |tag|
      tag.locals.show.send(tagname)
    end
  end
  
  ['location', 'address'].each do |tagname|
    tag "reverbnation:shows:each:#{tagname}" do |tag|
      value = tag.locals.show.send(tagname)
      country = tag.locals.country
      if country
        value.sub(/,? #{country}$/, '').sub(/, *$/, '')
      else
        value
      end
    end
  end

  tag "reverbnation:shows:each:url" do |tag|
    tag.locals.show.link
  end
  
  Time::DATE_FORMATS[:show_date] = '%b %e'
  Time::DATE_FORMATS[:show_time] = '%l:%M %p'

  ['date', 'time'].each do |tagname, format|
    tag "reverbnation:shows:each:#{tagname}" do |tag|
      custom = tag.attr['custom']
      if custom
        tag.locals.show.datetime.strftime(custom)
      else
        tag.locals.show.datetime.to_s("show_#{tag.name}".to_sym)
      end
    end
  end
  
  # TODO: reverbnation:shows:each:artists
end
