class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :zip_code, :remember_me, :fb_hash
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :interests
  has_and_belongs_to_many :shows

  #validates :zip_code, :length => {:is => 5} #make sure the zip code given is 5 digits

  def get_liked_shows
    return self.shows
  end

  def get_preferred_categories
    return self.categories
  end

  def self.find_for_facebook_oauth(auth)
    user = User.find_by_fb_hash(auth[:uid])
    if !user
      user = User.new(:first_name => auth[:extra][:raw_info][:name],
                      :fb_hash => auth[:uid],
                      :email => auth[:info][:email],
                      :password => Devise.friendly_token[0,20]
                      )
      user.save
    end
    return User.find_by_fb_hash(auth[:uid])
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
