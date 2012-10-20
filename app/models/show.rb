require 'rubygems'
require 'hpricot'
require 'open-uri'

class Show < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :venues  
  has_many :showtimes, :dependent => :destroy

  validates :venues, :length => { :minimum => 1 }


  #Method to call to parse all xml listings and add to database
  def parse_xml
    raw = open("http://www.tixbayarea.com/xml/listings.xml")
    xml_doc = Hpricot::XML(raw)
    xml_doc.search(:event).each do |event|

      stored_show = previous_record_show(event)

      if stored_show
        update_stored_showtime(event, stored_show)
        update_stored_prices(event, stored_show)
      else
        create_show_record(event)
        create_venue_record(event)
        create_showtime_records(event)
        create_category_records(event)
        #save the show record, and associate the venue, showtime and category with it
      end
    end
  end

  ######Helper methods

  #store the xml elements relating to symbols in syms into hash
  def store_fields(xml, hash, syms)
    syms.each do |field|
      field_str = field.to_s
      #strip off the _as_text if in symbol name
      if (field.to_s =~ /_as_text/)
        field_str = field_str.partition("_to")[0]
      end
      hash[field_str.to_sym] = xml.at(field).inner_html
    end
  end

  #returns array of date_ids associated with this event
  def event_dates(event)
    date = event.at('upcoming_dates')              
    result = []
    date.search(:event_date).each do |event_date|
      date_id = event_date.to_html.match(/"([^"]+)"/)[1]
      time_str = event_date.at('date').inner_html + 
        " " + event_date.at('time_note').inner_html
      result << [date_id, time_str]
    end
    return result
  end

  #store the elt_name information into the hash
  def match_prices(xml, hash, elt_name)
    #match to get the prices
    text = xml.at(elt_name).inner_html
    if (text.eql?('FREE'))
      result = 0
    elsif (text.eql?('SOLD OUT'))
      result = -1
    else
      result = (text.
                match(/\$(\S*)\s*/)[1].
                to_f * 100).round
    end
    elt_symbol = "#{elt_name}_low".to_sym
    hash[elt_symbol] = result
    if (text =~ /\s\$(\S*)/)
      result = (text.
                match(/\s\$(\S*)/)[1].
                to_f * 100).round
    end
    elt_symbol = "#{elt_name}_high".to_sym
    hash[elt_symbol] = result
  end

  def previous_record_show(event)
    event_id = event.to_html.match(/"([^"]+)"/)[1].to_i

    #check database to see if it contains the id
    return Shows.where(:event_id => event_id).first
  end

  def update_stored_showtime(event, stored_show)
    #Get the information of dates for current XML feed
    dates_info = event_dates(event)

    #Check and see if XML feed has new date, not previously in db, add if found
    dates = []
    dates_info.each do |tuple|
      db_date = previous_dates.where(:date_id => tuple[0]).first
      if not db_date
        #date not in database, add and link to the stored_show
        # TODO FINSIH HERE
        db_date[1]
      end
      dates << tuple[0]
    end

    #If stored time is in db but not XML feed, delete
    previous_dates = stored_show.showtimes
    previous_dates.each do |prev_date|
      if not dates.include?(prev_date.date_id)
        prev_date.destroy()
      end
    end
  end

  def update_stored_prices(event, stored_show)
    hash_show = {}
    match_prices(event, hash_show, 'our_price_range')
    match_prices(event, hash_show, 'full_price_range')

    stored_show.update(hash_show)
  end

  def create_show_record(event)
    hash_show = {}
    event_id = event.to_html.match(/"([^"]+)"/)[1].to_i
    hash_show[:event_id] = event_id

    #store the price ranges in hash
    match_prices(event, hash_show, 'our_price_range')
    match_prices(event, hash_show, 'full_price_range')

    #simply store string result of following fields
    show_sym = [:image, :summary_as_text, :title_as_text, :link, :headline_as_text]
    store_fields(event, hash_show, show_sym)

    hash_show[:sold_out] = 
      event.at('venue').at('capacity').inner_html.eql?('true')

    #create show from hash here
    return hash_show
  end

  def create_venue_record(event)
    hash_venue = {}
    venue = event.at('venue')

    venue_sym = [:image, :link, :name]

    store_fields(venue, hash_venue, venue_sym)

    hash_venue[:geocode_longitude] = 
      venue.at('geocode_longitude').inner_html.to_f
    hash_venue[:geocode_latitude] =
      venue.at('geocode_latitude').inner_html.to_f
    hash_venue[:capacity] =
      venue.at('capacity').inner_html.to_i

    #extract the inner fields of adddress for venue information
    address = venue.at('address')

    #getting postal code to number
    #check for 0 for failing
    hash_venue[:postal_code] =
      venue.at('postal_code').inner_html.to_i

    #get default strings for following fields
    address_sym = [:locality, :country_name, :region, :street_address]
    store_fields(address, hash_venue, address_sym)

    return hash_venue
  end

  def create_showtime_records(event)
    #fill in all corresponding upcoming dates for event
    dates_info = event_dates(event)    

    dates_info.each do |tuple|
      hash_showtime = {:date_id => tuple[0], :date_time => DateTime.parse(tuple[1])}
      #create showtimes from hash
    end

    #dates full, create each and return
    return dates_info
  end

  def create_category_records(event)
    event.at('category_list').search(:category).each do |category|
      name = category.at('name').inner_html
      hash_category = {:name => name}
    end

    #category full, create each and return
  end
end
