class RecommendationsController < ApplicationController
  def index
  end
  def form
    @title = "Recommendation Form"
    # @user =
  end
  def signup
    #if logged in:
    redirect_to :action=>"form"
    #else
  end
end
