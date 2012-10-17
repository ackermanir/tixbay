class CreateDateAndTimes < ActiveRecord::Migration
  def change
    create_table :date_and_times do |t|
      t.integer :event_id
      t.datetime :date_time

      t.timestamps
    end
  end
end
