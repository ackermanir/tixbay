class Show < ActiveRecord::Base
  has_and_belongs_to_many :categorys

  has_many :venues
  validates :venue, :length => { :minimum => 1 }

  has_many :date_times
  validates :date_time, :length => { :minimum => 1 }

end
