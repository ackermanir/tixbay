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
      fake_shows = [[fake_show, 0], [fake_show, 0]]

      location = {}
      location['street_address'] = "2111 Bancroft Way"
      location['city'] = "Berkeley"
      location['region'] = "CA"
      location['zip_code'] = 94709
      distance = 25
      Show.get_closest_shows(fake_shows,location,distance)
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
      fake_show.get_distance(20,20).should > 0
    end
  end

  describe "self.recommend_shows" do
    it "handles having no upper price bound or date end" do
      Show.stub(:price_greater).and_return(Show)
      Show.should_not_receive(:price_lower).with(-1)
      Show.stub(:joins).and_return(Show)
      Show.stub(:date_later).and_return(Show)
      Show.should_not_receive(:date_earlier).with(nil)
      Show.stub(:in_categories).and_return(Show)
      Show.recommend_shows
    end
    it "filters based on location and upper bound price" do
      Show.stub(:price_greater).and_return(Show)
      Show.should_receive(:price_lower).with(100).and_return(Show)
      Show.stub(:joins).and_return(Show)
      Show.stub(:in_categories).and_return(Show)
      Show.stub(:date_later).and_return(Show)
      Show.stub(:all).and_return([])
      Show.should_receive(:get_closest_shows).with([], "look", 20).and_return([])
      Show.recommend_shows([0, 100],
                           Category.all_categories,
                           [DateTime.now, nil],
                           "look", 20)
    end
  end

  describe "similar_shows" do
    it "calls recommend with correct arguments" do
      s = Show.new
      c1 = mock('category')
      c2 = mock('category')
      c1.stub(:name).and_return('Film')
      c2.stub(:name).and_return('Food')
      s.stub(:categories).and_return([c1, c2])
      s.stub(:our_price_range_low).and_return(100)
      s.stub(:our_price_range_high).and_return(200)
      v = mock('venue')
      v.stub(:location_hash).and_return("loc")
      s.stub(:venue).and_return(v)
      DateTime.stub(:now).and_return("now")
      Show.should_receive(:recommend_shows).
        with([80.0, 240.0],
             ['Film', 'Food'],
             [DateTime.now, nil],
             "loc", 20, nil, nil).and_return([])
      s.similar_shows
    end
  end

  describe "self.rank_keyword" do
    it "should sort order by weight the shows" do
      s1 = Show.new
      s2 = Show.new
      s1.stub(:keyword_search).and_return(1)
      s2.stub(:keyword_search).and_return(2)
      Show.rank_keyword([[s1, 0], [s2, 0]], "").should == [[s1, 1.5], [s2, 3]]
    end
  end

  describe "keyword_search" do
    it "extract the list of words relevant to show categories" do
      s = Show.new
      c1 = mock('category')
      c1.stub(:name).and_return("Jazz")
      s.stub(:categories).and_return([c1])
      s.stub(:headline).and_return('Come see blues')
      s.stub(:summary).and_return('It is new and classical jazz')
      s.keyword_search({'Music' => ['blues', 'jazz'],
                         'Theatre' => ['classical', 'new']}).
        should == 3
    end
    it "get the weighting for both headline and summary" do
      s = Show.new
      c1 = mock('category')
      c1.stub(:name).and_return('Classical')
      s.stub(:categories).and_return([c1])
      s.stub(:headline).and_return('Come see new Blues')
      s.stub(:summary).and_return('It is Classical Jazz and blues')
      s.keyword_search({'Music' => ['blues', 'jazz'],
                         'Theatre' => ['classical', 'new']}).
        should == 4
    end
  end

  describe "features" do
    it "returns hash from features" do
      s = Show.new
      s.our_price_range_low = 1000
      s.our_price_range_high = 9000
      s.venue = Venue.new
      s.venue.locatlity = "oka"
      s.stub(:categories).and_return(['film'])
    end
  end

  def features
    hash = {}
    hash['price_range'] = [(our_price_range_low / 100).floor, 
                           (our_price_range_high / 100).floor]
    hash['locality'] = venue.locality
    hash['category'] = categories
    return hash
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
