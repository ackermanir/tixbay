require 'rubygems'
require 'nokogiri'

class Event
  #keep xml associated with event as instance variable
  def initialize(xml)
    @event = xml
    @show = nil
  end
  
  #checks if there is a previous record, updates or creates it accordingly
  def process_event
    previous_record_show
    if @show
      update_stored_showtime
      update_stored_prices
    elsif category_whitelist
      create_show_record
      create_venue_record
      create_showtime_records
      create_category_records
      save_show
    end
  end
  
  #########
  # Helpers
  #########

  #seam added for testing
  def save_show
    @show.save
  end

  #store the xml elements relating to symbols in syms into hash
  def store_fields(xml, hash, syms)
    syms.each do |field|
      field_str = field.to_s
      #strip off the _as_text if in symbol name
      matchData = field_str.match(/(.*)_as_text/)
      val = xml.xpath(field.to_s).inner_html
      if (matchData)
        field_str = matchData[1]
        val = val.gsub('&amp;', '&')
      end
      hash[field_str.to_sym] = val
    end
  end
  
  #return true if show has at least one category we want
  def category_whitelist
    valid = ['Theater', 'Performing Arts', 'Popular Music', 'Jazz',
             'Classical', 'Classic Rock', 'Film']
    create = false
    @event.xpath('category_list').xpath('category').each do |category|
      name = category.xpath('name').inner_html.gsub('&amp;', '&')
      create |= valid.include?(name)
    end
    return create
  end

  #returns array of date_ids from xml's upcoming dates field
  def event_dates
    date = @event.xpath('upcoming_dates')
    result = []
    date.search(:event_date).each do |event_date|
      date_id = event_date.to_s.match(/"([^"]+)"/)[1].to_i
      time_note = event_date.xpath('time_note').inner_html
      if time_note.include?('TBA')
        time_note = ""
      end
      time_str = event_date.xpath('date').inner_html + " " + time_note
      result << [date_id, time_str]
    end
    return result
  end
  
  #store the elt_name information into the hash
  def match_prices(hash, elt_name)
    #match to get the prices
    text = @event.xpath(elt_name).inner_html
    if (text.include?('FREE'))
      result = 0
    elsif (text.eql?('SOLD OUT'))
      result = -1
    else
      result = (text.
                match(/\$(\S*)\s*/)[1].
                to_f * 100).round.to_i
    end
    elt_symbol = "#{elt_name}_low".to_sym
    hash[elt_symbol] = result
    if (text =~ /\s\$(\S*)/)
      result = (text.
                match(/\s\$(\S*)/)[1].
                to_f * 100).round.to_i
    end
    elt_symbol = "#{elt_name}_high".to_sym
    hash[elt_symbol] = result
  end
  
  #checks if event already seen and loads it into @show
  def previous_record_show
    event_id = @event.to_s.match(/"([^"]+)"/)[1].to_i
    #check database to see if it contains the id
    @show = Show.where(:event_id => event_id).first
  end
  
  #updates the showtimes in @show based on the date info from xml
  def update_stored_showtime
    #Get the information of dates for current XML feed
    dates_info = event_dates
    
    previous_dates = @show.showtimes
    #Check and see if XML feed has new date, not previously in db, add if found
    dates = []
    dates_info.each do |tuple|
      db_date = previous_dates.where(:date_id => tuple[0]).first
      if not db_date
        #date not in database, add and link to the @show
        @show.showtimes.create(:date_id => tuple[0],
                               :date_time => DateTime.parse(tuple[1]))
        #TODO validate the build
      end
      dates << tuple[0]
    end
    
    #If stored time is in db but not XML feed, delete
    previous_dates.each do |prev_date|
      if not dates.include?(prev_date.date_id)
        prev_date.destroy()
      end
    end
  end
  
  def update_stored_prices
    hash_show = {}
    match_prices(hash_show, 'our_price_range')
    match_prices(hash_show, 'full_price_range')
    
    Show.update(@show.id, hash_show)
    #TODO validate the update
  end
  
  def create_show_record
    hash_show = {}
    event_id = @event.to_s.match(/"([^"]+)"/)[1].to_i
    hash_show[:event_id] = event_id
    
    #store the price ranges in hash
    match_prices(hash_show, 'our_price_range')
    match_prices(hash_show, 'full_price_range')
    
    #simply store string result of following fields
    show_sym = [:summary_as_text, :title_as_text, :headline_as_text]
    store_fields(@event, hash_show, show_sym)

    #store the correct link, the second one
    hash_show[:link] = @event.xpath('link').inner_html

    hash_show[:image_url] = @event.xpath('image').inner_html
    hash_show[:sold_out] = @event.xpath('sold_out').inner_html.eql?('true')
    
    @show = Show.new(hash_show)
  end
  
  def create_venue_record
    hash_venue = {}
    venue = @event.xpath('venue')

    venue_sym = [:link, :name]    
    store_fields(venue, hash_venue, venue_sym)
    
    #Uniquely identify venues by their link
    db_venue = Venue.where(:link => hash_venue[:link]).first
    
    if (db_venue)
      db_venue.shows << @show
      db_venue.save
      #TODO validate the save      
        
    else
      hash_venue[:image_url] =
      @event.xpath('venue').xpath('image').inner_html

      hash_venue[:geocode_longitude] = 
        venue.xpath('geocode_longitude').inner_html.to_f
      hash_venue[:geocode_latitude] =
        venue.xpath('geocode_latitude').inner_html.to_f
      hash_venue[:capacity] =
        venue.xpath('capacity').inner_html.to_i
        
      #extract the inner fields of adddress for venue information
      address = venue.xpath('address')

      hash_venue[:postal_code] =
        address.xpath('postal_code').inner_html.to_i
      
      #get default strings for following fields
      address_sym = [:locality, :country_name, :region, :street_address]
      store_fields(address, hash_venue, address_sym)
        
      ven = Venue.new(hash_venue)
      ven.shows << @show
      ven.save
      #TODO validate the saves
    end
  end
    
  def create_showtime_records
    #fill in all corresponding upcoming dates for event
    dates_info = event_dates
    
    dates_info.each do |tuple|
      hash_showtime = {:date_id => tuple[0],
        :date_time => DateTime.parse(tuple[1])}
      @show.showtimes.build(hash_showtime)
    end
    
  end
  
  def create_category_records
    @event.xpath('category_list').xpath('category').each do |category|
      name = category.xpath('name').inner_html.gsub('&amp;', '&')
      
      #Uniquely identify categories by name
      db_category = Category.where(:name => name).first
      if db_category
        @show.categories << db_category
      else
        @show.categories.build(:name => name)
      end
      #TODO verify builds
    end
  end
end
