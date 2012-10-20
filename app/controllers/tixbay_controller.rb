class TixbayController < ApplicationController
  def index
	redirect_to :action => :theater
  end
  def theater 
	@title = "Theater"
	render :body
  end
  def music
	@title = "Music"
	render :body
  end
  def film
	@title = "Films"
	render :body 
  end
  def all_culture
	@title = "All Cultures"
	render :body
  end
end
