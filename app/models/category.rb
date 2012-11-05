class Category < ActiveRecord::Base
  has_and_belongs_to_many :shows

  @@category_types = {
    "theater" => ['Theater', 'Performing Arts'],
    "music" => ['Popular Music', 'Jazz', 'Classical', 'Classic Rock'],
    "film" => ['Film'],
    "all culture" => ['Theater', 'Performing Arts', 'Popular Music', 'Jazz',
                      'Classical', 'Classic Rock', 'Film']
  }

  def self.all_categories
    return @@category_types["all culture"]
  end

  def self.categories_by_title(title)
    return @@category_types[title]
  end
  
  def self.shows_from_category(category)
    shows = []
    Category.where(:name => @@category_types[category]).each do |c|
      shows += c.shows.to_a
    end
    return shows.uniq
  end
end
