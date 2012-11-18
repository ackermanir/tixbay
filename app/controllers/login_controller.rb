class LoginController < ApplicationController

  def facebook_success

    auth_hash = request.env['omniauth.auth']
    #render :text => auth_hash.inspect

    # failure if no access given
    if !auth_hash["credentials"].has_key?("token")
      flash[:notice] = "Failed to provide access through facebook."
      redirect_to '/login'
    end

    user = User.find_by_facebook_uid(auth_hash["uid"])

    # new user
    if !user
      user = User.new :name => auth_hash["user_info"]["name"], :email => auth_hash["user_info"]["email"], :facebook_uid => auth_hash["uid"], :facebook_access_token => auth_hash["credentials"]["token"]
    end

    #login
    session[:id] = user.id
    redirect_to '/'

  end

  def facebook_failure
    flash[:notice] = "Failed to provide access through facebook."
    redirect_to '/login'
  end

end
