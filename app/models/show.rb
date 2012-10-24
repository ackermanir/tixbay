require 'rubygems'
require 'nokogiri'
require 'open-uri'

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
  
end
