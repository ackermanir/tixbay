class TixbayController < ApplicationController
  def index
    redirect_to :action => :theater
  end
  def theater 
    theater_category = ['Theater', 'Performing Arts']
    @title = "theater"
    @shows = []
    Category.where(:name => theater_category).each do |c|
      @shows += c.shows.to_a
    end
    render :body
  end
  def music
    music_category = ['Popular Music', 'Jazz', 'Classical', 'Classic Rock']
    @title = "music"
    @shows = []
    Category.where(:name => music_category).each do |c|
      @shows += c.shows.to_a
    end
    render :body
  end
  def film
    @title = "film"
    @shows = Category.where(:name => 'Film').first.shows
    render :body 
  end
  #for now simply call theater
  def all_culture
    all_category = ['Theater', 'Performing Arts', 'Popular Music', 'Jazz',
                    'Classical', 'Classic Rock', 'Film']
    @title = "all culture"
    @shows = []
    Category.where(:name => all_category).each do |c|
      @shows += c.shows.to_a
    end
    render :body    
  end
end
