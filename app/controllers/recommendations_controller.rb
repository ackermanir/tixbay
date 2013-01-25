require 'will_paginate/array'

class RecommendationsController < ApplicationController

  #Helper methods for keyword
  def keyword_hash_from_params(params)
    keywords = {}
    params["recommendation"]["keyword"].each do |word, value|
      if value == "1"
        decompose = word.split
        title = decompose[0]
        keyword = decompose[1]
        if keywords[title]
          keywords[title] << keyword
        else
          keywords[title] = [keyword]
        end
      end
    end
    return keywords
  end
  def keyword_hash_to_string(hash)
    output = ""
    hash.each do |key, value|
      output += key.to_s + ": "
      value.each do |wrd|
        output += wrd.to_s + " "
      end
    end
    output = output[0 .. -2]
    return output
  end
  def keyword_string_to_hash(str)
    output = {}
    ary = {}
    if not str.nil?
        ary = str.split
    end
    cur_cat = nil
    ary.each do |wrd|
      cat = /(.*):$/.match(wrd)
      if cat != nil
        cur_cat = cat[1]
        output[cur_cat] = []
      else
        output[cur_cat] << wrd
      end
    end
    return output
  end


  #before_filter :authenticate_user!

  def index
    if params.has_key? :recommendation
      if params[:recommendation][:location]["zip_code"] == "" || params[:recommendation][:location]["zip_code"].length != 5
        flash[:notice] = "You must enter a valid zip code to get recommendations."
        redirect_to :action => :form
        return
      end
    end

    @title = "recommended"

    args = {}

    if user_signed_in?
        if params.has_key? :recommendation
            #save data in database here
            maxprice = -1
            if params[:recommendation]["maxprice"] != ""
              maxprice = (params[:recommendation]["maxprice"].to_f * 100).to_i
            end

            current_user.update_attribute(:max_tix_price, maxprice)
            current_user.update_attribute(:street_address,params[:recommendation][:location]["street_address"])
            current_user.update_attribute(:city, params[:recommendation][:location]["city"])
            current_user.update_attribute(:state, params[:recommendation][:location]["region"])
            current_user.update_attribute(:zip_code,params[:recommendation][:location]["zip_code"])
            current_user.update_attribute(:travel_radius, params["recommendation"]["distance"].to_i)
            current_user.update_attribute(:keyword, keyword_hash_to_string(keyword_hash_from_params(params)))


            current_user.categories.delete_all

            params["recommendation"]["category"].each do |category, value|
                if value == "1"
                    if category == "Theatre"
                        category = "Theater"
                    end
                    if not Category.find_by_name(category).nil?
                        current_user.categories << Category.find_by_name(category)
                    end
                end
            end
            current_user.save
        end
        if current_user.zip_code.nil?
            #haven't fill out form yet, redirect to form yet
            redirect_to :action=>"form"
            return
        else
            #get data from database and load it to params
            args["price_range"] = [0, current_user.max_tix_price]
            args["zip_code"] = current_user.zip_code
            args["location"] = {}
            args["location"]["street_address"] = current_user.street_address
            args["location"]["city"] = current_user.city
            args["location"]["region"] = current_user.state
            args["location"]["zip_code"] = current_user.zip_code
            args["distance"] = current_user.travel_radius
            if current_user.keyword
              args["keyword"] = keyword_string_to_hash(current_user.keyword)
            else
              args["keyword"] = nil
            end
            if current_user.categories.length == 0
              args["categories"] = Category.all_categories
            else
              args["categories"] = []
              current_user.categories.each do |c|
                if c.name == "Theater"
                   args["categories"] << "Theatre"
                else
                   args["categories"] << c.name
                end

              end
            end
            #FIX-ME: need to add time to session
            args["dates"] = [DateTime.now, nil]
        end
    else #non-signed in users
        if params["recommendation"]
          session[:recommendation] = params["recommendation"]
        elsif session[:recommendation]
          params["recommendation"] = session[:recommendation]
        else
          redirect_to :action=>"form"
        end
        #FIX-ME: need to destroy the session if the users exit the forms

        price_range = params[:recommendation]["maxprice"]
        if price_range == ""
          args["price_range"] = [0, -1]
        else
          args["price_range"] = [0, (price_range.to_f * 100).to_i]
        end

        location = params["recommendation"]["location"]
        if location["zip_code"] == ""
          args["location"] = nil
        else
          args["location"] = location
        end

        args["distance"] = params["recommendation"]["distance"].to_i

        categories = []
        params["recommendation"]["category"].each do |category, value|
          if value == "1"
            categories << category
          end
        end
        if categories.length == 0
          args["categories"] = Category.all_categories
        else
          args["categories"] = categories
        end
        startdate = params["recommendation"]["startdate"]
        enddate = params["recommendation"]["enddate"]
        if startdate["month"] != "" && startdate["day"] != "" && startdate["year"] != "" && enddate["month"] != "" && enddate["day"] != "" && enddate["year"]
          args["dates"] = [DateTime.new(startdate["year"].to_i, startdate["month"].to_i, startdate["day"].to_i), DateTime.new(enddate["year"].to_i, enddate["month"].to_i, enddate["day"].to_i)]
        else
          args["dates"] = [DateTime.now, nil]
        end

        keywords = keyword_hash_from_params(params)
        args["keyword"] = keywords

    end # end non signed-in user processing

    if user_signed_in?
      user = current_user
      @favorited = user.get_recent_fav
      @viewed = user.get_recent_view
    else
      user = nil
    end
    @shows = Show.recommend_shows(price_range=args["price_range"], categories=args["categories"], dates=args["dates"], location=args["location"], distance=args["distance"], user=user, keywords=args["keyword"])

    if @shows.length == 0
      @noresults = "No results were found. Please broaden your criteria and search again."
    end

    params["recommendation"] = nil

    @shows = @shows.paginate(:page => params[:page], :per_page => 15)

    render "category/body"

  end

  #Helper method that sets the appropriate variables given the value passed in from the db
  def set_keyword_variables(val)
    if val == "Comedy"
      @comedy = true
    elsif val == "Drama"
      @drama = true
    elsif val == "Tragedy"
      @tragedy = true
    elsif val == "Musical"
      @musical = true
    elsif val == "Solo"
      @solo = true
    elsif val == "Jazz"
      @jazz = true
    elsif val == "Cabaret"
      @cabaret = true
    elsif val == "Classical"
      @classical = true
    elsif val == "Indie-Rock"
      @indie_rock = true
    elsif val == "Animated"
      @animated = true
    elsif val == "Documentary"
      @documentary = true
    elsif val == "Silent"
      @silent = true
    elsif val == "Festival"
      @festival = true
    elsif val == "Short"
      @short = true
    elsif val == "Drive-In"
      @drive_in = true
    elsif val == "Classic"
      @classic = true
    elsif val == "Sci-Fi"
      @scifi = true
    elsif val == "Premiere"
      @premiere = true
    elsif val == "Family"
      @family = true
    end
  end

  #Helper method that sets the appropriate variables for categories given the value passed in from the db
  def set_categories_variables(val)
    if val == "Performing Arts"
      @performing_cat = true
    elsif val == "Popular Music"
      @pop_music_cat = true
    elsif val == "Jazz"
      @jazz_cat = true
    elsif val == "Classical"
      @classical_cat = true
    elsif val == "Classic Rock"
      @classic_rock_cat = true
    elsif val == "Family"
      @family_cat = true
    elsif val == "Food & Social"
      @food_social_cat = true
    end
  end

  def recommended
    #if not logged in
    # redirect_to :actions=>"login"
    #elsif no saved answers
    redirect_to :actions=>"form"
    #else
    # @title = "Recommended Shows"
    # @shows = []
    # @shows = based on user
    # render "tixbay/body"
  end

  def form
    @title = "recommended"
    @is_new = true

    if user_signed_in?
      if params['edit']
        @is_new = false
        user = current_user
        @first_name = user.first_name

        keyword_hash = keyword_string_to_hash(user.keyword)

        keyword_hash.each do |k,v|
          v.each do |ele|
            set_keyword_variables(ele) 
          end
        end

        @street_address = user.street_address
        @city = user.city
        @state = user.state
        @zip_code = user.zip_code

        @dist = user.travel_radius.to_i

        if user.max_tix_price.to_i >= 0
          @maxprice = user.max_tix_price.to_i / 100
        else
          @maxprice = 0
        end

        categories = user.categories

        categories.each do |val|
          set_categories_variables(val.name)
          if val.name == "Theater"
            @theatre_cat = true
          elsif val.name == "Comedy"
            @comedy_cat = true
          elsif val.name == "Film"
            @film_cat = true
          end
        end
      else
        @first_name = current_user.first_name if current_user
        @is_new = true
        @theatre_cat = true
        @performing_cat = true
        @pop_music_cat = true
        @jazz_cat = true
        @classical_cat = true
        @classic_rock_cat = true
        @film_cat = true
        @comedy_cat = true
        @family_cat = true
        @food_social_cat = true
      end
    else
      @first_name = current_user.first_name if current_user
      @is_new = true
      @theatre_cat = true
      @performing_cat = true
      @pop_music_cat = true
      @jazz_cat = true
      @classical_cat = true
      @classic_rock_cat = true
      @film_cat = true
      @comedy_cat = true
      @family_cat = true
      @food_social_cat = true
    end
  end

  def login
    #if logged in:
    if user_signed_in?
      redirect_to :action=>"index"
    else
      redirect_to "/users/sign_in"
    end
  end
end
