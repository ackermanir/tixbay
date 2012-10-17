class CreateShowtimes < ActiveRecord::Migration
  def change
    create_table :showtimes do |t|
      t.integer :date_id
      t.datetime :date_time

      t.timestamps
    end
  end
end
