require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'mathn'
require 'will_paginate/array'

class Show < ActiveRecord::Base
  has_and_belongs_to_many :categories
  belongs_to :venue
  has_many :interests
  has_many :showtimes, :dependent => :destroy
  has_many :users, :through => :interests

  #Scopes used for recommendation filtering
  scope :price_greater, lambda { |price|
    {:conditions => ["our_price_range_high >= ?", price]} }
  scope :price_lower, lambda { |price|
    {:conditions => ["our_price_range_low <= ?", price]} }
  scope :in_categories, lambda { |categories|
    {:conditions => {'categories.name' => categories}} }
  scope :date_later, lambda { |start_date|
    {:conditions => ["showtimes.date_time >= ?", start_date]} }
  scope :date_earlier, lambda { |end_date|
    {:conditions => ["showtimes.date_time <= ?", end_date]} }
  scope :not_sold_out, :conditions => {"sold_out" => false}
  scope :commutable, :conditions => 
    {'venues.locality' => Venue.default_localities}

  #Method to call to parse all xml listings and add to database
  def self.fill_from_xml(location = File.join(Rails.root, "app",
                                              "data", "listings.xml"))
    raw = File.open(location)
    xml_doc = Nokogiri::XML(raw)
    xml_doc.xpath("//event").each do |event|
      ev = Event.new(event)
      ev.process_event
    end
  end

  def self.get_closest_shows(weighted_shows, location, distance)
    url = "http://maps.googleapis.com/maps/api/geocode/xml?address="
    url += (location["street_address"].gsub /\s+/, '+')  + ","
    url += (location["city"].gsub /\s+/, '+')  + ","
    url += location["region"] + "+" + location["zip_code"].to_s
    url +=  "&sensor=true"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    xml_doc = Nokogiri::XML(data)
    location = xml_doc.xpath("//location")
    myLat = location.xpath("lat").inner_html.to_f
    myLong = location.xpath("lng").inner_html.to_f

    result = []
    weighted_shows.each do |pair|
      s = pair[0]
      w = pair[1]
      show_distance = s.get_distance(myLat, myLong)
      if show_distance < distance
        w -= 15 * (show_distance.to_f / distance)
        result << [s, w]
      end
    end
    return result
  end

  def get_distance(myLat,myLong)
     v = Venue.find(self.venue_id)
     #approximate distance in miles by latitude/longitude degrees
     Math.sqrt((69*(myLat - v.geocode_latitude))**2 + (69*(myLong - v.geocode_longitude))**2)
  end

"""
Filters and order of application:
  Query search:
    Price Range - Default to free through infinite or [0, -1]
    Category ID - Filtering removes non-matching, default to all categories
    Dates - Shows between date range, defaults starting from today
  Done on array of shows:
    location - hash with 'street_address', 'city', 'region', and 'zip_code',
              zip code the only thing necessary
    Distance - miles, default to 10
    user - utilized past show clicked to weight shows
    Keyword - category => [keywords]

Defaults to recommending all shows
"""
  def self.recommend_shows(price_range = [0, -1],
                           categories = Category.all_categories,
                           dates = [DateTime.now, nil],
                           location = nil,
                           distance = 10,
                           user = nil,
                           keywords = nil
                           )
    #Filter based on price and categories
    shows = Show.price_greater(price_range[0]).
      joins(:showtimes).date_later(dates[0])
    shows = shows.date_earlier(dates[1]) unless not dates[1]
    shows = shows.price_lower(price_range[1]) unless price_range[1] == -1
    shows = shows.joins(:categories).in_categories(categories)
    shows = shows.all.uniq

    weighted_shows = []
    shows.each {|s| weighted_shows << [s, 0]}

    #weight based on user past, distance, and keywords
    weighted_shows = Show.get_closest_shows(weighted_shows, location, distance) unless not location
    weighted_shows = user.weight_show_from_past(weighted_shows) unless not user
    weighted_shows = Show.rank_keyword(weighted_shows, keywords) unless not keywords

    #sort weighted shows to return largest first
    weighted_shows.sort! do |a,b|
      b[1] <=> a[1]
    end
    shows = []
    weighted_shows.each {|pair| shows << pair[0] }
    return shows
  end

"""
Returns all shows for the category that are
  Commutable according to default_localities in category
  Have a date later than the time of search
  Not sold out
"""
  def self.category_shows(title)
    categories = Category.categories_by_title(title)
    shows = Show.joins(:categories).in_categories(categories).
      not_sold_out.
      joins(:showtimes).date_later(DateTime.now).
      joins(:venue).commutable

    shows = shows.all.uniq
    return shows
  end

"""
Returns all shows similar to show object.
How it chooses similarity:
  Only looks at shows who have at least one category the same as it.
  Price new show's highest price >= 0.8 * this show's lowest price and
    new show's lowest price <= 1.2 * this show's highest price
  Shows within 20 miles of the venue of this show.
"""
  def similar_shows
    category = []
    self.categories.each do |c|
      category << c.name
    end
    price_range = [our_price_range_low * 0.8, our_price_range_high * 1.2]
    location = venue.location_hash
    shows = Show.recommend_shows(price_range, category,
                                 [DateTime.now, nil],
                                 location, 20, nil, nil)
    return (shows.uniq - [self])
  end

  def self.rank_keyword(shows, keywords)
    pairings = []
    shows.each do |pair|
      show = pair[0]
      weight = pair[1]
      weight += 1.5 * show.keyword_search(keywords)
      pairings << [show, weight]
    end
    return pairings
  end

"""
  Weights this show based on the keywords, using each occurence in a
  description as two points and one point in the summary.
"""
  def keyword_search(keywords)
    #finds weight of string of words from keywords
    def weight_in_string(str, keywords)
      weight = 0
      str = str.downcase
      keywords.each {|k| weight += str.scan(k.downcase).count}
      return weight
    end

    category = []
    categories.each {|c| category << c.name}
    keyword = []
    keywords.each do |key, value|
      #See if show's category intersect with keyword title's categories
      title = key.downcase
      title = "all culture" if title == "all"
      matching = Category.categories_by_title(key.downcase)
      if matching & category != []
        value.each {|wrd| keyword << wrd.downcase}
      end
    end
    weight = 2 * weight_in_string(self.headline, keyword)
    weight += weight_in_string(self.summary, keyword)
    return weight
  end

  #Features of a show for recommendations based on previous shows
  def features
    hash = {}
    hash['price_range'] = [(our_price_range_low / 100).floor, 
                           (our_price_range_high / 100).floor]
    hash['locality'] = venue.locality
    hash['category'] = categories
    return hash
  end

  def self.merge_features(shows, favorite_shows)
    all_features = {}
    all_features['prices'] = []
    all_features['categories'] = {}
    all_features['locality'] = {}
    for show in shows
      features = show.features
      weight = 1
      if favorite_shows.include?(show)
        weight = 2
      end
      price_range = features['price_range']
      price_low = price_range[0].floor
      price_low = 0 if (price_low < 0)
      price_high = price_range[1].floor
      prices = all_features['prices']
      while (prices.length < price_high + 1)
        prices << 0
      end
      for index in (price_low .. price_high)
        prices[index] += weight
      end
      all_features['prices'] = prices

      cats = features['category']
      for cat in cats
        if all_features['categories'][cat] != nil
          all_features['categories'][cat] += weight
        else
          all_features['categories'][cat] = weight
        end
      end
      city = features['locality']
      if all_features['locality'][city] != nil
        all_features['locality'][city] += weight
      else
        all_features['locality'][city] = weight
      end
    end

    def self.normalize_hash(hash)
      max_hash = hash.keys.max {|a, b| hash[a] <=> hash[b]}
      max_val = hash[max_hash]
      for key in hash.keys
        hash[key] = hash[key].to_f / max_val
      end
      return hash
    end
    def self.normalize_array(ary)
      max_ary = ary.max
      for index in (0 .. ary.length - 1)
        ary[index] = ary[index].to_f / max_ary
      end
      return ary
    end
    #normalize
    all_features['prices'] = normalize_array(all_features['prices'])
    all_features['categories'] = normalize_hash(all_features['categories'])
    all_features['locality'] = normalize_hash(all_features['locality'])
    return all_features
  end

  #returns formated string of prices specified by whose
  def price_format(whose)
    #Helper method
    def cent_string(cents)
      cents = cents.to_i
      if cents == 0
        return "Free"
      elsif cents == -1
        return "Sold Out"
      end
      output = (cents % 100).to_s
      if output.length != 2
        output += '0'
      end
      output = "$" + (cents / 100).floor.to_s + "." + output
      return output
    end

    if whose == 'full'
      low = cent_string(full_price_range_low)
      high = cent_string(full_price_range_high)
    else
      low = cent_string(our_price_range_low)
      high = cent_string(our_price_range_high)
    end
    output = low
    if high != low
      output = "#{output} - #{high}"
    end
    return output
  end

  #returns a string from the first to last date for this show
  def date_string
    times = []
    showtimes.all.each do |time|
      times << time.date_time
    end
    times = times.sort
    first_date = times.first.to_date.strftime('%m/%d')
    last_date = times.last.to_date.strftime('%m/%d')
    output = first_date
    if last_date != first_date
      output += " - " + last_date
    end
    return output
  end

end
