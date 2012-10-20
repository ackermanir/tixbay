class CreateShowShowtimeTable < ActiveRecord::Migration
  def up
    create_table :shows_showtimes, :id => false do |t|
      t.references :show, :showtime
    end
    add_index :shows_showtimes, [:show_id, :showtime_id]
  end

  def down
    drop_table :shows_showtimes
  end
end
