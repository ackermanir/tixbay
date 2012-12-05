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
    ary = str.split
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
    @first_name = current_user.first_name if current_user
    @is_new = true

    if user_signed_in?
      if params['edit']
        @is_new = false
        user = current_user

      end
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
