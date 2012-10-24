require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'

class Show < ActiveRecord::Base
  has_and_belongs_to_many :categories
  belongs_to :venue  
  has_many :showtimes, :dependent => :destroy

  #Method to call to parse all xml listings and add to database
  def self.fill_from_web
    raw = File.open(File.join(Rails.root, "app", "data", "listings.xml"))
    xml_doc = Nokogiri::XML(raw)
    xml_doc.xpath("//event").each do |event|
      ev = Event.new(event)
      ev.process_event
    end
  end

  def self.get_closest_show
  	url = "http://maps.googleapis.com/maps/api/geocode/xml?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=true"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
	xml_doc = Hpricot::XML(data)
	xml_doc.search(:result).each do |event|
      puts event
	end  
  end

  #might move this in venue, so we can cache the geocoding without using up the quota
  #even though json might be better, we had been using xml already
  def get_geocoding
	venue = Venue.find(self.venue_id)
  	url = "http://maps.googleapis.com/maps/api/geocode/xml?address="
    url += (venue.street_address.gsub /\s+/, '+')  + ","
	url += (venue.locality.gsub /\s+/, '+')  + ","
    url += venue.region + "+" + venue.postal_code.to_s
    url +=  "&sensor=true"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
	xml_doc = Hpricot::XML(data)
	location = xml_doc.search(:location)
	location.search(:lat).inner_html + "," + location.search(:lng).inner_html
  end
  
end
