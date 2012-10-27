class TixbayController < ApplicationController
  def index
    redirect_to :action => :theater
  end
  def theater 
    theater_category = ['Theater', 'Performing Arts']
    @title = "theater"
    @shows = Category.shows_from_category(@title)
    render :body
  end
  def music
    music_category = ['Popular Music', 'Jazz', 'Classical', 'Classic Rock']
    @title = "music"
    @shows = Category.shows_from_category(@title)
    render :body
  end
  def film
    @title = "film"
    @shows = Category.shows_from_category(@title)
    render :body 
  end
  #for now simply call theater
  def all_culture
    all_category = ['Theater', 'Performing Arts', 'Popular Music', 'Jazz',
                    'Classical', 'Classic Rock', 'Film']
    @title = "all culture"
    @shows = Category.shows_from_category(@title)
    render :body    
  end
end
