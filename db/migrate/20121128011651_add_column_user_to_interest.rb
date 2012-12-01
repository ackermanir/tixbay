class AddColumnUserToInterest < ActiveRecord::Migration
  def change
    change_table :interests do |t|
      t.references :user
    end
  end

  def down
    remove_column :interests, :user
  end
end
