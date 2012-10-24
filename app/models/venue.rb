class Venue < ActiveRecord::Base
  has_many :shows

  #Gives one line address of venue
  def full_address
    output = street_address + ", " + locality + ", " +
      region + " " + postal_code.to_s
    return output
  end

end
