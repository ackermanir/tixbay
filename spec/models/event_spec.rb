# spec/models/event_spec.rb
require 'spec_helper'
require 'rspec-rails'
require 'nokogiri'

describe Event do
  it "sets event when initialized" do
    ev = Event.new("<test>")
    ev.instance_variable_get(:@event).should == "<test>"
    ev.instance_variable_get(:@show).should == nil
  end
  describe "process_event" do
    it "works" do
      input = %Q{<listings><event id="46404"><deal_of_the_day>today_only</deal_of_the_day><full_price_range>$17.00</full_price_range><summary_as_text>Show twice.</summary_as_text><image>improv.jpg</image><venue><capacity>194</capacity><geocode_longitude>-122.433704</geocode_longitude><image>front.jpg</image><geocode_latitude>37.805033</geocode_latitude><link>theater</link><address><locality>San Francisco</locality><country_name>United States</country_name><postal_code>94123</postal_code><street_address>Marina Blvd At Buchanan St</street_address><region>CA</region></address><name>Bayfront Theater</name></venue><headline_as_text>BATS Improv</headline_as_text><link>sub=46404</link><upcoming_dates><event_date id="619189"><time_note>8:00pm (Improvised Horror Musical)</time_note><date>2012-10-20</date></event_date></upcoming_dates><title_as_text>BATS Improv Comedy</title_as_text><sold_out>false</sold_out><category_list><category id="1"><name>Film</name></category></category_list><our_price_range>FREE - $8.50</our_price_range></event></listings>}
      File.stub(:open).and_return(input)
      Show.fill_from_xml
      Show.fill_from_xml
    end
    it "should only update if it finds a previous show" do
      ev = Event.new("help")
      ev.stub(:previous_record_show)
      ev.instance_variable_set(:@show, "T") 
      ev.should_receive(:update_stored_showtime).with(no_args())
      ev.should_receive(:update_stored_prices).with(no_args())
      ev.process_event
    end
    it "should create a show if one is not found" do
      mk = mock('show')
      mk.stub(:save)
      ev = Event.new("help")
      ev.stub(:previous_record_show)
      ev.stub(:save_show)
      ev.stub(:category_whitelist).and_return(true)
      ev.should_receive(:create_venue_record)
      ev.should_receive(:create_showtime_records)
      ev.should_receive(:create_show_record)
      ev.should_receive(:create_category_records)
      ev.process_event
    end
  end
  describe "store_fields" do
    it "should strip off _as_text from the symbol" do
      hash = {}
      syms = [:test_as_text]
      xml = Nokogiri::XML("<test_as_text>hl</test_as_text>")
      ev = Event.new("bogus")
      ev.store_fields(xml, hash, syms)
      hash[:test].should == "hl"
    end
    it "should place the matching field with symbol in hash" do
      hash = {}
      syms = [:cat]
      xml = Nokogiri::XML("<cat>hl</cat>")
      ev = Event.new("bogus")
      ev.store_fields(xml, hash, syms)
      hash[:cat].should == "hl"
    end
  end
  describe "category_whitelist" do
    it "return false if category not in list" do
      input = %Q{<event id="46404"><category_list><category id="1"><name>Comedy</name></category></category_list></event>}
      xml = Nokogiri::XML(input)
      ev = Event.new(xml.xpath('event').first)
      ev.category_whitelist.should == false
    end
  end
  describe "event_dates" do
    it "should return info in upcoming dates xml into array" do
      xml = Nokogiri::XML('<upcoming_dates><event_date id="619189">' +
                         '<time_note>8:00pm (Improvised Horror Musical)' +
                         '</time_note><date>2012-10-20</date></upcoming_dates>')
      ev = Event.new(xml)
      ar = ev.event_dates
      ar[0].should == [619189, "2012-10-20 8:00pm (Improvised Horror Musical)"]
    end
    it "should handle TBA dates by getting rid of time" do
      xml = Nokogiri::XML('<upcoming_dates><event_date id="619189">' +
                         '<time_note>Date TBA: Two-Day Pass' +
                         '</time_note><date>2012-10-20</date></upcoming_dates>')
      ev = Event.new(xml)
      ar = ev.event_dates
      ar[0].should == [619189, "2012-10-20 "]
    end
  end
  describe "match_prices" do
    it "should set prices to zero for SOLD OUT" do
      hash = {}
      xml = Nokogiri::XML('<our_price_range>SOLD OUT</our_price_range>')
      ev = Event.new(xml)
      ev.match_prices(hash, "our_price_range")
      hash[:our_price_range_high].should == -1
      hash[:our_price_range_high].should == -1
    end
    it "should have two same prices if only given one price" do
      xml = Nokogiri::XML('<our_price_range>$7.50</our_price_range>')
      hash = {}
      ev = Event.new(xml)
      ev.match_prices(hash, "our_price_range")
      hash[:our_price_range_low].should == 750
      hash[:our_price_range_high].should == 750
    end
    it "should set relevant price to 0 if FREE" do
      xml = Nokogiri::XML('<our_price_range>FREE - $7.50</our_price_range>')
      hash = {}
      ev = Event.new(xml)
      ev.match_prices(hash, "our_price_range")
      hash[:our_price_range_low].should == 0
      hash[:our_price_range_high].should == 750
    end
  end
  describe "previous_record_show" do
    it "should set look up show based on event id from xml" do
      xml = Nokogiri::XML('<event id="65324"><deal_of_the_day/></event>')
      ev = Event.new(xml.xpath('event').first)
      Show.should_receive(:where).with(:event_id => 65324).and_return([])
      ev.previous_record_show
    end
    it "should set the instance variable show" do
      xml = Nokogiri::XML('<event id="62650"><deal_of_the_day/></event>')
      ev = Event.new(xml)
      Show.stub(:where).and_return(["l"])
      ev.previous_record_show
      ev.instance_variable_get(:@show).should == "l"
    end
  end
  describe "update_stored_showtime" do
    it "should create new showtime if new one is found" do
      ev = Event.new("bogus")
      sh = mock('show')
      ar = mock('array')
      ar.stub(:where).and_return([])
      ar.should_receive(:create)
      ar.stub(:each).and_return([])
      sh.stub(:showtimes).and_return(ar)

      ev.stub(:event_dates).and_return([[1, "800pm"]])
      ev.instance_variable_set(:@show, sh)
      ev.update_stored_showtime
    end
    it "should destroy showtime if old one not found" do
      ev = Event.new("bogus")
      sh = mock('show')  #show
      ar = mock('array') #previous_dates
      d = mock('date')   #prev_date
      ar.stub(:where).and_return(["l"])
      sh.stub(:showtimes).and_return(ar)
      ar.should_receive(:each).and_yield(d)
      d.should_receive(:date_id).and_return(0)
      d.should_receive(:destroy)

      ev.stub(:event_dates).and_return([[1, "800pm"]]) #dates_info
      ev.instance_variable_set(:@show, sh)
      ev.update_stored_showtime
    end
  end
  describe "update_stored_prices" do
    it "should " do
      ev = Event.new("bogus")
      sh = mock('show')
      sh.stub(:id).and_return(1)
      ev.instance_variable_set(:@show, sh)
      ev.should_receive(:match_prices).with({}, /price_range/).exactly(2).times
      Show.stub(:update)
      ev.update_stored_prices
    end
  end
  describe "create_show_record" do
    it "should fill in all relevent fields" do
      input = %Q{<event id="46404"><summary_as_text>Show twice.</summary_as_text><image>improv.jpg</image><headline_as_text>BATS</headline_as_text><link>sub=46404</link><title_as_text>Comedy</title_as_text><sold_out>false</sold_out></event>}
      xml = Nokogiri::XML(input)
      ev = Event.new(xml.xpath('event').first)
      ev.stub(:match_prices)
      hash_show = {:sold_out => false, :image_url => 'improv.jpg',
        :summary => 'Show twice.', :title => 'Comedy',
        :link => 'sub=46404', :headline => 'BATS',
        :event_id => 46404}
      Show.should_receive(:new).with(hash_show)
      ev.create_show_record
    end
  end
  describe "create_venue_record" do
    it "should not recreate a venue that already exists" do
      input = %Q{<event id="46404"><venue><link>front.jpg</link><name>Bay</name></venue></event>}
      xml = Nokogiri::XML(input)
      ev = Event.new(xml.xpath('event').first)
      v = mock('ven')
      v.stub(:shows).and_return([])
      v.should_receive(:save)
      Venue.stub(:where).and_return([v])
      ev.create_venue_record
    end
    it "should create a new venue object if new venue" do
      input = %Q{<event id="46404"><venue><capacity>194</capacity><geocode_longitude>-122.3</geocode_longitude><image>front.jpg</image><geocode_latitude>37</geocode_latitude><link>theater</link><address><locality>San</locality><country_name>US</country_name><postal_code>94</postal_code><street_address>Marina</street_address><region>CA</region></address><name>Bay</name></venue></event>}
      xml = Nokogiri::XML(input)
      ev = Event.new(xml.xpath('event').first)
      v = mock('ven')
      v.stub(:shows).and_return([])
      v.should_receive(:save)
      hash_venue = {:capacity => 194, :geocode_longitude => -122.3,
        :image_url => 'front.jpg', :geocode_latitude => 37,:link => 'theater', 
        :locality => 'San', :country_name => 'US', :postal_code => 94,
        :street_address => 'Marina', :name => 'Bay', :region => 'CA'}
      Venue.should_receive(:new).with(hash_venue).and_return(v)
      ev.create_venue_record
    end
  end
  describe "create_showtime_record" do
    it "should have new showtimes linked to show" do
      ev = Event.new("bogus")
      ev.stub(:event_dates).and_return([[0, "800pm"]])
      ar = mock('showtimes')
      ar.should_receive(:build).with({:date_id => 0,
                                       :date_time => DateTime.parse("800pm")})
      sh = mock('show')
      sh.stub(:showtimes).and_return(ar)
      ev.instance_variable_set(:@show, sh)
      ev.create_showtime_records
    end
  end
  describe "create_category_record" do
    it "should reuse previous entry for category" do
      input = %Q{<event id="46404"><category_list><category id="1"><name>Comedy</name></category></category_list></event>}
      xml = Nokogiri::XML(input)
      ev = Event.new(xml.xpath('event').first)
      sh = mock('show')
      sh.should_receive(:categories).and_return([])
      ev.instance_variable_set(:@show, sh)
      Category.should_receive(:where).with({:name => 'Comedy'}).
        and_return(["l"])
      ev.create_category_records
    end
    it "should link show to category" do
      input = %Q{<event id="46404"><category_list><category id="1"><name>Comedy</name></category></category_list></event>}
      xml = Nokogiri::XML(input)
      ev = Event.new(xml.xpath('event').first)
      ar = mock('showtimes')
      ar.should_receive(:build).with({:name => 'Comedy'})
      sh = mock('show')
      sh.should_receive(:categories).and_return(ar)
      ev.instance_variable_set(:@show, sh)
      Category.should_receive(:where).and_return([])
      ev.create_category_records
    end
  end
end
