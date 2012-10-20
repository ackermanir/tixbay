class Showtime < ActiveRecord::Base
  belongs_to :shows 
  validates :date_id, :pressence => true
end
