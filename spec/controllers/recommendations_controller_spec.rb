require 'spec_helper'
require 'rspec-rails'
require 'will_paginate/array'

describe RecommendationsController do
  include Devise::TestHelpers
  describe "index" do
    it "calls filtering model method" do
      user = FactoryGirl.create(:user)
      sign_in user
      params = {
        "recommendation" => {
          "keyword" => {
            "Film" => "1",
            "Comedy" => "0"
          },
          "location" => {
            "street_address" => "",
            "city" => "",
            "region" => "",
            "zip_code" => "94704"
          },
          "startdate" => {
            "year" => "2012",
            "day" => "3",
            "month" => "2"
          },
          "enddate" => {
            "year" => "2012",
            "day" => "4",
            "month" => "10"
          },
          "distance" => "25",
          "maxprice" => "300",
          "category" => {
            "Film" => "1",
            "Comedy" => "0"
          }
        }
      }

      Show.should_receive(:recommend_shows).with(price_range=[0, 300],
                                                categories = ["Film"],
                                                dates = [DateTime.new(2012, 2, 3), DateTime.new(2012,10,4)],
                                                location = { "street_address" => "",
                                                  "city" => "",
                                                  "region" => "",
                                                  "zip_code" => "94704"
                                                },
                                                distance = 25,
                                                keywords = ["Film"]
                                                 )
      @shows.stub(:paginate)
      @shows.should_receive(:length).and_return(15)
      post :index, :recommendation => params["recommendation"]
    end
  end
end
