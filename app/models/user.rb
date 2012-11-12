class User < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :interests
  has_and_belongs_to_many :shows

  validates :zip_code, :length => {:is => 5} #make sure the zip code given is 5 digits

  def get_liked_shows
    return self.shows
  end

  def get_preferred_categories
    return self.categories
  end

end
