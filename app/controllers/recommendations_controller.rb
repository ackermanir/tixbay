class RecommendationsController < ApplicationController

  # when submit form
  def index
    @title = "Recommended Shows"
    @shows = []
    # @shows = processed form
    #if logged in
    # save answers/shows
    render "tixbay/body"
  end

  def custom
    #if not logged in
    # redirect_to :actions=>"login"
    #elsif no saved answers
    redirect_to :actions=>"form"
    #else
    # @title = "Recommended Shows"
    # @shows = []
    # @shows = based on user
    # render "tixbay/body"
  end

  def form
    @title = "Recommendation Form"
  end

  def login
    #if logged in:
    redirect_to :action=>"form"
  end
end
