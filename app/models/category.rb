class Category < ActiveRecord::Base
  has_and_belongs_to_many :shows
  
  def self.shows_from_category(page)
    category_types = {"theater" => ['Theater', 'Performing Arts'],
      "music" => ['Popular Music', 'Jazz', 'Classical', 'Classic Rock'],
      "film" => ['Film'],
      "all culture" => ['Theater', 'Performing Arts', 'Popular Music', 'Jazz',
                        'Classical', 'Classic Rock', 'Film'] }
    shows = []
    Category.where(:name => category_types[page]).each do |c|
      shows += c.shows.to_a
    end
    return shows
  end
end
