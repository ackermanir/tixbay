class Venue < ActiveRecord::Base
  has_many :shows

  #Gives one line address of venue
  def full_address
    output = street_address + ", " + locality + ", " +
      region + " " + postal_code.to_s
    return output
  end

  def self.default_localities
    return ['San Francisco', 'Oakland', 'Alameda', 'Berkeley', 'San Jose', 'Palo Alto']
  end

  #return location hash understandable by Terence's API
  def location_hash
    return {'street_address' => street_address,
      'city' => locality, 'region' => region, 'zipcode' => postal_code.to_s}
  end

end
