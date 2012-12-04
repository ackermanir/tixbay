require 'will_paginate/array'

class CategoryController < ApplicationController
  def index
    redirect_to :action => :theatre
  end
  def theatre
    theatre_category = ['Theatre', 'Performing Arts']
    @title = "theatre"
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
end
