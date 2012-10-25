class RecommendationsController < ApplicationController

  # POST /recommendations
  # when submit form
  def index
    # @listings = processed form
    # if logged in, save answers
    # render :recommendations
  end

  # GET /recommendations
  # when click on 'custom'
  def custom
    # if not logged in or has no saved answers
    redirect_to :actions=>"login"
    # @listings = based on user
    # render :recommendations
  end

  #should POST to index
  def form
    @title = "Recommendation Form"
    # @user =
  end

  def login
    #if logged in:
    redirect_to :action=>"form"
  end
end
