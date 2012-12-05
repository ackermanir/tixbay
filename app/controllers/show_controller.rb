require 'will_paginate/array'

class ShowController < ApplicationController

  def index
    render :show_page
  end

  def favorite
    show_id = params['show_id']
    favorite = params['update']
    if user_signed_in?
      user = current_user
      if favorite == 'undo'
        user.unfavorite_a_show(show_id)        
      else
        user.favorite_a_show(show_id)
      end
    end
    render :fav_resp
  end

  def unfavorite
    show_id = params['show_id']
    user = current_user
    user.favorite_a_show(show_id)
    render :fav_resp
  end

  def show
    @current_show = Show.find(params['id'])
    @current_show_id = params['id']
    @shows = @current_show.similar_shows()
    @shows = @shows[0 ... 5]
    if user_signed_in?
      user = current_user
      @favorite = user.get_favorite_shows.include?(@current_show)
    end
    check_for_empty_shows()
    render :show_page
  end

  def check_for_empty_shows
    if @shows.empty?
      @noShows = true
    else
      @noShows = false
    end
  end
  
  def add_click_and_redirect
    if user_signed_in?
      User.find(current_user.id).add_click_to_interest(params['id'], params['num'])
      redirect_to params['link']
    else
      redirect_to params['link']
    end
  end

  def favorite_shows
    if user_signed_in?
      @favorited = User.find(current_user.id).get_favorite_shows
    end
  end

  def viewed_shows
    if user_signed_in?
      @viewed = User.find(current_user.id).get_viewed_shows
    end
  end
end
