require 'rubygems'
require 'hpricot'
require 'open-uri'

class Show < ActiveRecord::Base
  has_and_belongs_to_many :categories
  belongs_to :venue  
  has_many :showtimes, :dependent => :destroy

  #validates :venue, :length => { :minimum => 1 }

  #Method to call to parse all xml listings and add to database
  def self.fill_from_web
    raw = File.open(File.join(Rails.root, "app", "models", "listings.xml"))
    xml_doc = Hpricot::XML(raw)
    xml_doc.search(:event).each do |event|
      ev = Event.new(event)
      ev.process_event
    end
  end
  
end
