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

  describe "price_format" do
    it "Handles sold out shows" do
      s = Show.new
      s.stub(:our_price_range_low).and_return(-1)
      s.stub(:our_price_range_high).and_return(-1)
      s.price_format("our").should == "Sold Out"
    end
    it "Handles Free shows" do
      s = Show.new
      s.stub(:our_price_range_low).and_return(0)
      s.stub(:our_price_range_high).and_return(200)
      s.price_format("our").should == "Free - $2.00"
    end
    it "Handles full price range" do
      s = Show.new
      s.stub(:full_price_range_low).and_return(3333)
      s.stub(:full_price_range_high).and_return(6523)
      s.price_format("full").should == "$33.33 - $65.23"
    end
  end

  describe "date_string" do
    it "Handles one date" do
      s = Show.new
      sh = mock('showtimes')
      sh.stub(:all).and_return([Showtime.new(:date_time => 
                                             DateTime.parse("2012/11/26"))])
      s.stub(:showtimes).and_return(sh)
      s.date_string.should == "11/26"
    end
    it "Sort three dates out of order" do
      s = Show.new
      sh = mock('showtimes')
      sh.stub(:all).and_return([Showtime.new(:date_time => 
                                             DateTime.parse("2012/12/26")),
                               Showtime.new(:date_time => 
                                             DateTime.parse("2012/8/26")),
                               Showtime.new(:date_time => 
                                             DateTime.parse("2012/10/26"))])
      s.stub(:showtimes).and_return(sh)
      s.date_string.should == "08/26 - 12/26"
    end
  end
end
