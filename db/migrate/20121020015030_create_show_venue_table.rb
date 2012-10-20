class CreateShowVenueTable < ActiveRecord::Migration
  def up
    create_table :shows_venues, :id => false do |t|
      t.references :show, :venue
    end
    add_index :shows_venues, [:show_id, :venue_id]
  end

  def down
    drop_table :shows_venues
  end
end
