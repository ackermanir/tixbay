class TixbayController < ApplicationController
  def index
	redirect_to :action => :theater
  end
  def theater 
	@title = "Theater"
	@shows = Category.find_by_name("Theater").shows
	render :body
  end
  def music
	@title = "Music"
	@shows = Category.find_by_name("Jazz").shows
	render :body
  end
  def film
	@title = "Films"
	@shows = Category.find_by_name("Film").shows
	render :body 
  end
  def all_culture
	@title = "All Cultures"
	render :body
  end
end
