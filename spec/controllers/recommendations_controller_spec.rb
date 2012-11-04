require 'spec_helper'
require 'rspec-rails'

describe RecommendationsController do
  describe "index" do
    it "calls filtering model method" do
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
          "distance" => "25",
          "maxprice" => "300",
          "category" => {
            "Film" => "1",
            "Comedy" => "0"
          }
        }
      }
      Show.should_receive(:recommendShows).with(price_range=[0, 300],
                                                location = { "street_address" => "",
                                                  "city" => "",
                                                  "region" => "",
                                                  "zip_code" => "94704"
                                                },
                                                categories = ["Film"],
                                                distance = "25",
                                                keywords = ["Film"]
                                                )
      post :index, :recommendation => params["recommendation"]
    end
  end
end
