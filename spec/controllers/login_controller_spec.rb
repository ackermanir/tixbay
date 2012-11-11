require 'spec_helper'
require 'rspec-rails'

describe LoginController do

  describe "facebook_success" do

    it "should sign up the user if they are new" do

      pending("implement facebook login")

      fake_auth_hash = {
        :uid => '12345',
        :info => {
          :name => "My Name",
          :email => "myname@mysite.com"
        },
        :credentials => {
          :token => 'abcdef'
        }
      }

      fake_omniauth = {
        'omniauth.auth' => fake_auth_hash
      }

      fake_request = mock('request')
      fake_request.stub(:env).and_return(fake_omniauth)
      User.should_receive(:find_by_facebook_uid).with('12345').and_return(nil)
      fake_session = mock('session')

      arg = {
        :name => "My Name",
        :email => "myname@mysite.com",
        :facebook_uid => '12345',
        :access_token => 'abcdef'
      }
      fake_user = mock('user')
      fake_user.stub(:id).and_return(10)
      User.should_receive(:new).with(hash_including(arg)).and_return(fake_user)
      fake_session.should_receive(:[]=).with(10)
      post :facebook_success, {}
    end

    it "should login the user if they are returning" do

      pending("implement login")

      fake_auth_hash = {
        :uid => '12345',
        :info => {
          :name => "My Name",
          :email => "myname@mysite.com"
        },
        :credentials => {
          :token => 'abcdef'
        }
      }

      fake_omniauth = {
        'omniauth.auth' => fake_auth_hash
      }

      fake_request = mock('request')
      fake_request.stub(:env).and_return(fake_omniauth)
      fake_user = mock('user')
      fake_user.stub(:id).and_return(10)
      User.should_receive(:find_by_facebook_uid).with('12345').and_return(fake_user)
      fake_session = mock('session')

      User.should_not_receive(:new)
      fake_session.should_receive(:[]=).with(10)
      post :facebook_success
    end

    it "should fail if no access token" do

      pending("implement login")

      fake_auth_hash = {
        :uid => '12345',
        :info => {
          :name => "My Name",
          :email => "myname@mysite.com"
        },
        :credentials => {
        }
      }

      fake_omniauth = {
        'omniauth.auth' => fake_auth_hash
      }

      fake_request = mock('request')
      fake_request.stub(:env).and_return(fake_omniauth)
      fake_user = mock('user')
      User.should_receive(:find_by_facebook_uid).with('12345').and_return(fake_user)

      post :facebook_success
      response.should redirect_to '/login'

    end

  end

  describe "facebook_failure" do
    it "should redirect to login" do
      pending("implement login")
      post :facebook_failure
      response.should redirect_to '/login'
    end
  end

end
