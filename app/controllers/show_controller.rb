class ShowController < ApplicationController

  def index
    render :show_page
  end

  def show
    @current_show = Show.find(params['id'])
    @current_show_id = params['id']
    @shows = @current_show.similar_shows()
    
    render :show_page
  end
end
