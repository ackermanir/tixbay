require 'will_paginate/array'

class RecommendationsController < ApplicationController

  #before_filter :authenticate_user!

  def index
    if not user_signed_in?
        redirect_to "/users/sign_in"
        return
    end

    @title = "recommended"
    
    args = {}

    if params["recommendation"]
      session[:recommendation] = params["recommendation"]
    elsif session[:recommendation]
      params["recommendation"] = session[:recommendation]
    end

    # if params[] is empty and there is no data stored 
    if current_user.zip_code.nil? and not params["recommendation"]
        redirect_to :action=>"form"
        return
    elsif not params["recommendation"]
        #get data from database
        #FIX-ME: need a get the whole list of preferences...
        params[:recommendation]["zip_code"] = current_user.zip_code
    end

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

    startdate = params["recommendation"]["startdate"]
    enddate = params["recommendation"]["enddate"]
    if startdate["month"] != "" && startdate["day"] != "" && startdate["year"] != "" && enddate["month"] != "" && enddate["day"] != "" && enddate["year"]
      args["dates"] = [DateTime.new(startdate["year"].to_i, startdate["month"].to_i, startdate["day"].to_i), DateTime.new(enddate["year"].to_i, enddate["month"].to_i, enddate["day"].to_i)]
    else
      args["dates"] = [DateTime.now, nil]
    end

    keywords = {}
    params["recommendation"]["keyword"].each do |word, value|
      if value == "1"
        decompose = word.split
        title = decompose[0]
        keyword = decompose[1]
        if keywords[title]
          keywords[title] << keyword
        else
          keywords[title] = [keyword]
        end
      end
    end
    args["keywords"] = keywords

    @shows = Show.recommend_shows(price_range=args["price_range"], categories=args["categories"], dates=args["dates"], location=args["location"], distance=args["distance"], keywords=args["keywords"])

    if @shows.length == 0
      @noresults = "No results were found. Please broaden your criteria and search again."
    end

    params["recommendation"] = nil

    @shows = @shows.paginate(:page => params[:page], :per_page => 15)
    
    render "category/body"

  end

  def recommended
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
    @title = "recommended"
  end

  def login
    #if logged in:
    if user_signed_in?
      redirect_to :action=>"index"
    else
      redirect_to "/users/sign_in"
    end
  end
end
