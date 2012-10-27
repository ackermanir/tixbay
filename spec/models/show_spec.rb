# spec/models/show_spec.rb
require 'spec_helper'
require 'rspec-rails'

describe Show do
  describe "fill_from_xml" do
    it "loads the xml file" do
      File.should_receive(:open).with(any_args()).and_return("<Hello>")
      Show.fill_from_xml
    end
    it "creates an Event object if there is event data" do
      test = %Q{<listings><event id="46404"><summary_as_html>BATS
                Improv</summary_as_html></event>}

      fake_event = mock('event')
      File.stub(:open).and_return(test)
      Event.should_receive(:new).with(any_args()).and_return(fake_event)
      fake_event.should_receive(:process_event).with(no_args())
      Show.fill_from_xml
    end
  end
  describe "get_closest_shows" do
    it "should go through a list of shows and call get_distances" do
      fake_show = mock('show')
      fake_show.should_receive(:get_distance).exactly(2).times.and_return(23.0)
      fake_shows = [fake_show, fake_show]

      location = {}
      location['street_address'] = "2111 Bancroft Way"
      location['city'] = "Berkeley"
      location['region'] = "CA"
      location['zip_code'] = 94709 
      Show.get_closest_shows(fake_shows,location) 
    end
  end
  describe 'get_distance' do
    it 'should return a distance' do
      fake_venue = mock('venue')
      fake_venue.stub(:geocode_latitude).and_return(19)
      fake_venue.stub(:geocode_longitude).and_return(20)
      Venue.stub(:find).and_return(fake_venue)
      fake_show = Show.new() 
      fake_show.stub(:venue_id).and_return(1)
      #fake_show.should_receive(:get_distance).and_return(0)
      fake_show.get_distance(20,20).should > 0
    end
  end
end
