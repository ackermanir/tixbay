class AddColumnShowToInterest < ActiveRecord::Migration
  def change
    change_table :interests do |t|
      t.references :show
    end
  end

  def down
    remove_column :interests, :show
  end
end
