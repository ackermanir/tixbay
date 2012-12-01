class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    auth_hash = request.env['omniauth.auth']

    @user = User.find_for_facebook_oauth(auth_hash)

    sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?

  end

end
