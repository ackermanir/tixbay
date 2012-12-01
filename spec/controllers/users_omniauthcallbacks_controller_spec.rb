require 'spec_helper'
require 'rspec-rails'
require 'rspec/mocks'

describe Users::OmniauthCallbacksController do
  include Devise::TestHelpers

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "facebook_success" do

    it "should sign up the user if they are new" do

      request.env["devise.mapping"] = Devise.mappings[:user]

      fake_auth_hash = {
        :uid => '12345',
        :info => {
          :email => "myname@mysite.com"
        },
        :extra => {
          :raw_info => {
            :name => "My Name"
          }
        }
      }

      request.env['omniauth.auth'] = fake_auth_hash

      User.should_receive(:find_by_fb_hash).with('12345').and_return(nil, @user)

      arg = {
        :first_name => "My Name",
        :email => "myname@mysite.com",
        :fb_hash => '12345',
      }
      fake_user = mock('user')
      fake_user.stub(:id).and_return(10)
      fake_user.stub(:save)
      User.should_receive(:new).with(hash_including(arg)).and_return(@user)

      post :facebook
    end

    it "should login the user if they are returning" do

      request.env["devise.mapping"] = Devise.mappings[:user]

      fake_auth_hash = {
        :uid => '12345',
        :info => {
          :email => "myname@mysite.com"
        },
        :extra => {
          :raw_info => {
            :name => "My Name"
          }
        }
      }

      request.env['omniauth.auth'] = fake_auth_hash

      fake_user = mock('user')

      User.should_not_receive(:new)

      User.stub(:find_by_fb_hash).with('12345').and_return(@user)

      post :facebook
    end

  end

end
