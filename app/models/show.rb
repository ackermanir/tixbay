require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'mathn'

class Show < ActiveRecord::Base
  has_and_belongs_to_many :categories
  belongs_to :venue  
  has_many :showtimes, :dependent => :destroy

  #Method to call to parse all xml listings and add to database
  def self.fill_from_xml(location = File.join(Rails.root, "app", 
                                              "data", "listings.xml"))
    raw = File.open(location)
    xml_doc = Nokogiri::XML(raw)
    xml_doc.xpath("//event").each do |event|
      ev = Event.new(event)
      ev.process_event
    end
  end

  def self.get_closest_shows(shows, location)
    url = "http://maps.googleapis.com/maps/api/geocode/xml?address="
    url += (location["street_address"].gsub /\s+/, '+')  + ","
    url += (location["city"].gsub /\s+/, '+')  + ","
    url += location["region"] + "+" + location["zip_code"].to_s
    url +=  "&sensor=true"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    xml_doc = Nokogiri::XML(data)
    location = xml_doc.xpath("//location")
    myLat = location.xpath("lat").inner_html.to_f
    myLong = location.xpath("lng").inner_html.to_f

    result = []
    shows.each do |s|
        distance = s.get_distance(myLat, myLong)
        if distance < 25 
            result << s
        end
    end 
    result
  end

  def get_distance(myLat,myLong) 
     v = Venue.find(self.venue_id)
     #approximate distance in miles by latitude/longitude degrees
     Math.sqrt((69*(myLat - v.geocode_latitude))**2 + (69*(myLong - v.geocode_longitude))**2)
  end

  #returns formated string of prices specified by whose
  def price_format(whose)
    #Helper method
    def cent_string(cents)
      if cents == 0
        return "Free"
      elsif cents == -1
        return "Sold Out"
      end
      output = (cents % 100).to_s
      if output.length != 2
        output += '0'
      end
      output = "$" + (cents / 100).to_s + "." + output
      return output
    end

    if whose == 'full'
      low = cent_string(full_price_range_low)
      high = cent_string(full_price_range_high)
    else
      low = cent_string(our_price_range_low)
      high = cent_string(our_price_range_high)
    end
    output = low
    if high != low
      output = "#{output} - #{high}"
    end
    return output
  end

  #returns a string from the first to last date for this show
  def date_string
    times = []
    showtimes.all.each do |time|
      times << time.date_time
    end
    times = times.sort
    first_date = times.first.to_date.strftime('%m/%d')
    last_date = times.last.to_date.strftime('%m/%d')
    output = first_date 
    if last_date != first_date
      output += " - " + last_date
    end
    return output
  end

end
