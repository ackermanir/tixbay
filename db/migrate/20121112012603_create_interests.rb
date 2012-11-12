class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.integer :click

      t.timestamps
    end
  end
end
