class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :zip_code, :remember_me, :fb_hash
  has_and_belongs_to_many :categories
  has_many :interests
  has_many :shows, :through => :interests

  #validates :zip_code, :length => {:is => 5} #make sure the zip code given is 5 digits

  #Update click for a user for a given show_id
  def add_click_to_interest(show_id, num)
    user_interests = self.interests.where(:show_id => show_id)
    if user_interests.any?
      user_interest = user_interests.first
      if Integer(user_interest.click) < Integer(num)
        user_interest.click = num
        user_interest.save
      end
    else
      self.interests.create(:show_id => show_id, :click => num)
    end
  end

  #Favorite a show for a user
  def favorite_a_show(show_id)
    previous_clicks = Interest.where('user_id' => self.id,
                                     'show_id' => show_id).all
    #Favoriting a show is most important, so update old connection
    if (previous_clicks != [])
      for elt in previous_clicks
        elt.click = 2
        elt.save
      end
    else
      fav = Interest.new(:show_id => show_id, :user_id => self.id, :click => 2)
      fav.save
    end
  end

  #Shows that the users has clicked purchase ticket
  def get_viewed_shows
    shows = Show.joins(:interests).where('interests.user_id' => self.id,
                                         'interests.click' => 1)
    return shows.all
  end

  #List of all shows that the users has favorited, but not those otherwise related
  def get_favorite_shows
    shows = Show.joins(:interests).where('interests.user_id' => self.id,
                                         'interests.click' => 2)
    return shows.all
  end

  def past_shows_features
    shows = Show.joins(:interests).where('interests.user_id' => self.id)
    all_features = {}
    all_features['prices'] = []
    all_features['categories'] = {}
    for show in shows.all
      features = show.features
      price_range = features['price_range']
      price_low = price_range[0].floor
      price_low = 0 if (price_low < 0)
      price_high = price_range[1].floor
      prices = all_features['prices']
      while (prices.length < price_high)
        prices << 0
      end
      for index in (price_low .. price_high)
        prices[index] += 1
      end
      all_features['prices'] = prices
      cats = features['category']
      for cat in cats
        if cats[cat] != nil
          all_features['categories'][cat] += 1
        else
          all_features['categories'][cat] = 1
        end
      end
    end

    #normalize
    max_price = prices.max
    for index in (0 .. all_features['prices'].length - 1)
      all_features[index] /= max_price
    end
    max_category = all_features.keys.max |a, b| do
      all_features[a] <=> all_features[b]
    end
    for key in all_features.keys
      all_features[key] /= max_category
    end
    return all_features
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
