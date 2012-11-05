class RecommendationsController < ApplicationController

  def index
    @title = "Recommended Shows"

    args = {}

    price_range = params["recommendation"]["maxprice"]
    if price_range == ""
      args["price_range"] = [0, -1]
    else
      args["price_range"] = [0, price_range.to_i]
    end

    location = params["recommendation"]["location"]
    if location["zip_code"] == ""
      args["location"] = nil
    else
      args["location"] = location
    end

    args["distance"] = params["recommendation"]["distance"].to_i

    categories = []
    params["recommendation"]["category"].each do |category, value|
      if value == "1"
        categories << category
      end
    end
    if categories.length == 0
      args["categories"] = Category.all_categories
    else
      args["categories"] = categories
    end

    keywords = []
    params["recommendation"]["keyword"].each do |word, value|
      if value == "1"
        keywords << word
      end
    end
    args["keywords"] = keywords

    @shows = Show.recommendShows(price_range=args["price_range"], categories=args["categories"], location=args["location"], distance=args["distance"], keywords=args["keywords"])

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
