class RecommendationsController < ApplicationController

  def index
    @title = "Recommended Shows"
    price_range = params["recommendation"]["maxprice"]
    location = params["recommendation"]["location"]
    distance = params["recommendation"]["distance"]

    categories = []
    params["recommendation"]["category"].each do |category, value|
      if value == "1"
        categories << category
      end
    end

    keywords = []
    params["recommendation"]["keyword"].each do |word, value|
      if value == "1"
        keywords << word
      end
    end

    if price_range[1] != "" && location["zipcode"] != ""
      @shows = Show.recommendShows(price_range=[0,price_range.to_i], location=location, categories=categories, distance=distance, keywords=keywords)
   elsif price_range[1] != ""
      @shows = Show.recommendShows(price_range=[0,price_range.to_i], categories=categories, distance=distance, keywords=keywords)
    else
      @shows = Show.recommendShows(location=location,categories=categories,distance=distance,keywords=keywords)
    end

    #if logged in
    # save answers/shows

    render "category/body"
  end

  def custom
    #if not logged in
    # redirect_to :actions=>"login"
    #elsif no saved answers
    redirect_to :actions=>"form"
    #else
    # @title = "Recommended Shows"
    # @shows = []
    # @shows = based on user
    # render "tixbay/body"
  end

  def form
    @title = "Recommendation Form"
  end

  def login
    #if logged in:
    redirect_to :action=>"form"
  end
end
