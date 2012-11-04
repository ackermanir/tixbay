# spec/models/venue_spec.rb
require 'spec_helper'
require 'rspec-rails'

describe Venue do
  describe "full_address" do
    it "formats address correctly" do
      v = Venue.new
      v.stub(:street_address).and_return("Marina Blvd")
      v.stub(:locality).and_return("San Francisco")
      v.stub(:region).and_return("CA")
      v.stub(:postal_code).and_return(94805)
      v.full_address.should == "Marina Blvd, San Francisco, CA 94805"
    end
  end
  describe "location_hash" do
    it "fills the hash correctly" do
      v = Venue.new
      v.stub(:street_address).and_return("Marina Blvd")
      v.stub(:locality).and_return("San Francisco")
      v.stub(:region).and_return("CA")
      v.stub(:postal_code).and_return(94805)
      v.location_hash.should == {"street_address" => "Marina Blvd",
        "city" => "San Francisco", "region" => "CA", "zipcode" => "94805"}
    end
  end
end
