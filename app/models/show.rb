require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'mathn'

class Show < ActiveRecord::Base
  has_and_belongs_to_many :categories
  belongs_to :venue  
  has_many :showtimes, :dependent => :destroy

  def self.fill_from_web
     raw = File.open(File.join(Rails.root, "app", "data", "listings.xml"))
     xml_doc = Nokogiri::XML(raw)
     xml_doc.xpath("//event").each do |event|
       ev = Event.new(event)
       ev.process_event
     end
  end

  #Method to call to parse all xml listings and add to database
  def self.get_closest_shows(street_address, locality, region, postal_code)
  	url = "http://maps.googleapis.com/maps/api/geocode/xml?address="
    url += (street_address.gsub /\s+/, '+')  + ","
	url += (locality.gsub /\s+/, '+')  + ","
    url += region + "+" + postal_code.to_s
    url +=  "&sensor=true"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
	xml_doc = Nokogiri::XML(data)
	location = xml_doc.xpath("//location")
	myLat = location.xpath("lat").inner_html.to_f
    myLong = location.xpath("lng").inner_html.to_f

	#failed attempt to calculate the distance inside database 
    #shows = Venue.find_all_by_sql("SELECT id, locality, ( 3959 * acos( cos( radians(37) ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(-122) ) + sin( radians(37) ) * sin( radians( lat ) ) ) ) AS distance FROM shows HAVING distance < 25 ORDER BY distance LIMIT 0 , 20;") 
	
	result = []
	distances = {}
	Show.find(:all).each do |s|
		v = Venue.find(s.venue_id)
		distance = Math.sqrt((69*(myLat - v.geocode_latitude))**2 + (69*(myLong - v.geocode_longitude))**2)
		if distance < 25 
			distances[s.id] = distance
			result << s
		end
	end	
	[result, distances]
  end

  #might move this in venue, so we can cache the geocoding without using up the quota
  def get_geocoding
	venue = Venue.find(self.venue_id)
  	url = "http://maps.googleapis.com/maps/api/geocode/xml?address="
    url += (venue.street_address.gsub /\s+/, '+')  + ","
	url += (venue.locality.gsub /\s+/, '+')  + ","
    url += venue.region + "+" + venue.postal_code.to_s
    url +=  "&sensor=true"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
	xml_doc = Nokogiri::XML(data)
	location = xml_doc.xpath("//location")
	location.xpath("lat").inner_html + "," + location.xpath("lng").inner_html
  end
  
end
