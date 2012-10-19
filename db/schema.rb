# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121017070536) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shows", :force => true do |t|
    t.string   "title"
    t.integer  "event_id"
    t.string   "headline"
    t.text     "summary"
    t.string   "link"
    t.integer  "our_price_range_low"
    t.integer  "our_price_range_high"
    t.integer  "full_price_range_low"
    t.integer  "full_price_range_high"
    t.boolean  "sold_out"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "showtimes", :force => true do |t|
    t.integer  "date_id"
    t.datetime "date_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.string   "link"
    t.integer  "postal_code"
    t.string   "country_name"
    t.string   "street_address"
    t.string   "region"
    t.string   "locality"
    t.integer  "capacity"
    t.decimal  "geocode_longitude"
    t.decimal  "geocode_latitude"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
