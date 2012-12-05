require 'spec_helper'

describe User do
  describe "weight_shows_from_past" do
    it "weights shows" do
      u = User.new
      u.stub(:past_shows_features).and_return({'categories' => {'Film' => 0}, 'locality' => {'Oakland' => 1},
                                                   'prices' => [1, 1, 1, 10, 1, 1, 1,]})
      s = Show.new
      s.stub(:our_price_range_low).and_return(0)
      s.stub(:our_price_range_high).and_return(10)
      s.venue = Venue.new
      s.venue.locality = 'Oakland'
      s.stub(:categories).and_return(['Film'])
      u.weight_show_from_past([[s, 0]]).should == [[s,7]]
    end
  end
end
