require 'will_paginate/array'

class ShowController < ApplicationController

  def index
    render :show_page
  end

  def show
    @current_show = Show.find(params['id'])
    @current_show_id = params['id']
    @shows = @current_show.similar_shows()
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
end
