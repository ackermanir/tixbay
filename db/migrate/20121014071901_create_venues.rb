class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.string :link
      t.integer :postal_code
      t.string :country_name
      t.string :street_address
      t.string :region
      t.string :locality
      t.integer :capacity
      t.decimal :geocode_longitude
      t.decimal :geocode_latitude
      t.string :image_url

      t.timestamps
    end
  end
end
