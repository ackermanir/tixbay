class TixbayController < ApplicationController
  def index
	redirect_to :action => :theater
  end
  def theater 
	@title = "theater"
	@shows = Category.find_by_name("Theater").shows
	render :body
  end
  def music
	@title = "music"
	@shows = Category.find_by_name("Jazz").shows
	render :body
  end
  def film
	@title = "film"
	@shows = Category.find_by_name("Film").shows
	render :body 
  end
  def all_culture
	@title = "all culture"
	@shows = Category.find_by_name("Theater").shows
	render :body
  end
  def preference
	@title = "nearby shows"
	@shows,@distances = Show.get_closest_shows("2111 Bancroft Way", "Berkeley", "CA", 94704)
	render :body
  end
end
