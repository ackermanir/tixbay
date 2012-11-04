class Venue < ActiveRecord::Base
  has_many :shows

  #Gives one line address of venue
  def full_address
    output = street_address + ", " + locality + ", " +
      region + " " + postal_code.to_s
    return output
  end

  #return location hash understandable by Terence's API
  def location_hash
    return {'street_address' => street_address,
      'city' => locality, 'region' => region, 'zipcode' => postal_code.to_s}
  end

end
