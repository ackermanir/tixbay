class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name

      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zip_code
      t.integer :travel_radius
      t.integer :max_tix_price

      t.string :fb_hash

      t.timestamps
    end
  end
end
