require 'will_paginate'

class CategoryController < ApplicationController
  def index
    redirect_to :action => :theater
  end
  def theater 
    theater_category = ['Theater', 'Performing Arts']
    @title = "theater"
    @shows = Category.shows_from_category(@title)
    @shows = Show.paginate(:page => params[:page], :per_page => 15)
    render :body
  end
  def music
    music_category = ['Popular Music', 'Jazz', 'Classical', 'Classic Rock']
    @title = "music"
    @shows = Category.shows_from_category(@title)
    @shows = Show.paginate(:page => params[:page], :per_page => 15)
    render :body
  end
  def film
    @title = "film"
    @shows = Category.shows_from_category(@title)
    @shows = Show.paginate(:page => params[:page], :per_page => 15)
    render :body 
  end
  #for now simply call theater
  def all_culture
    all_category = ['Theater', 'Performing Arts', 'Popular Music', 'Jazz',
                    'Classical', 'Classic Rock', 'Film']
    @title = "all culture"
    @shows = Category.shows_from_category(@title)
    @shows = Show.paginate(:page => params[:page], :per_page => 15)
    render :body    
  end
  def preference
	@title = "nearby shows"
	#default value
    @location = {}
	@location["street_address"] = "2111 Bancroft Way"
	@location["city"] = "Berkeley"
	@location["region"] = "CA"
	@location["zip_code"] = 94704
	if params.has_key?("street_address") 
	    @location["street_address"] = params[:street_address] 
    	@location["city"] = params[:city]
	    @location["region"] = params[:region] 
	    @location["zip_code"] = params[:zip_code]
	end
    shows = Show.all
	@shows = Show.get_closest_shows(shows, @location)
	render :body
  end
end
