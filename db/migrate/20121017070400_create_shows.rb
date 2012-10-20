class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :title
      t.integer :event_id
      t.string :headline
      t.text :summary
      t.string :link
      t.integer :our_price_range_low
      t.integer :our_price_range_high
      t.integer :full_price_range_low
      t.integer :full_price_range_high
      t.boolean :sold_out
      t.string :image_url
      t.references :venue

      t.timestamps
    end
  end
end
