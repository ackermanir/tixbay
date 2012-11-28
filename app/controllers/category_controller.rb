require 'will_paginate/array'

class CategoryController < ApplicationController
  def index
    redirect_to :action => :theater
  end
  def theater 
    @title = "theater"
    @shows = Show.category_shows(@title)
    @shows = @shows.paginate(:page => params[:page], :per_page => 15)
    render :body
  end
  def music
    @title = "music"
    @shows = Show.category_shows(@title)
    @shows = @shows.paginate(:page => params[:page], :per_page => 15)
    render :body
  end
  def film
    @title = "film"
    @shows = Show.category_shows(@title)
    @shows = @shows.paginate(:page => params[:page], :per_page => 15)
    render :body 
  end
  def all_culture
    @title = "all culture"
    @shows = Show.category_shows(@title)
    @shows = @shows.paginate(:page => params[:page], :per_page => 15)
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
