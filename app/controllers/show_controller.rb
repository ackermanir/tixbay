require 'will_paginate/array'

class ShowController < ApplicationController

  def index
    render :show_page
  end

  def favorite
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
      user_interests = User.find(current_user.id).interests.where(:show_id => params['id'])
      if user_interests.any?
        user_interest = user_interests.first
        user_interest.show_id = params['id']
        user_interest.click = params['num']
        user_interest.save
      else
        User.find(current_user.id).interests.create(:show_id => params['id'], :click => params['num'])
      end
      redirect_to params['link']
    else
      redirect_to params['link']
    end
  end
end
