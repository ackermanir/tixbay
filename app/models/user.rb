class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :remember_me, :fb_hash
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

  def weight_show_from_past(weighted_shows)
    features = past_shows_features
    if features['categories'] = {}
      return weighted_shows
    end
    reweighted = []
    weighted_shows.each do |pair|
      show = pair[0]
      weight = pair[1]
      #pricing
      low_price = (show.our_price_range_low / 100).floor
      high_price = (show.our_price_range_high / 100).floor
      price_weight = features['prices'].slice(low_price .. high_price).max
      weight += 2 * price_weight
      #locality
      locality = show.venue.locality
      locality_weight = features['locality'][locality]
      weight += 5 * locality_weight unless not locality_weight
      #categories
      cats = show.categories
      category_weight = 0
      for cat in cats
        cat_feature = features['categories'][cat]
        category_weight += cat_feature unless not cat_feature
      end
      weight += 4 * category_weight
      reweighted << [show, weight]
    end
    return reweighted
  end

  def past_shows_features
    shows = Show.joins(:interests).where('interests.user_id' => self.id)
    fav_shows = get_favorite_shows
    return Show.merge_features(shows, fav_shows)
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
