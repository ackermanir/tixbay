class RecommendationsController < ApplicationController

  def index
    @title = "Recommended Shows"
    @shows = []

    #setup filter by category
    categories = []
    params["recommendation"]["category"].each_pair do |k,v|
      if v == "1"
        categories << k
      end
    end
    shows = Category.where(:name => categories)

    #setup filter by date (only if user put a date)
    filterbydate = true
    params["recommendation"]["startdate"].each_pair do |k,v|
      if v == ""
        filterbydate = false
      end
    end
    params["recommendation"]["enddate"].each_pair do |k,v|
      if v == ""
        filterbydate = false
      end
    end
    if filterbydate == true
      start_date = DateTime.new(params["recommendation"]["startdate"]["year"].to_i, params["recommendation"]["startdate"]["month"].to_i, params["recommendation"]["startdate"]["day"].to_i)
      end_date = DateTime.new(params["recommendation"]["enddate"]["year"].to_i, params["recommendation"]["enddate"]["month"].to_i, params["recommendation"]["enddate"]["day"].to_i)
    end


    #filter by date and category
    Category.where(:name => categories).each do |c|
      @shows += c.shows.to_a
    end

    #filter by location
    # @shows = Show.get_closest_shows(@shows, params["location"])

    #if logged in
    # save answers/shows

    render "tixbay/body"
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
