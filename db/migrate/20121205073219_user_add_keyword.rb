class UserAddKeyword < ActiveRecord::Migration
  def up
    add_column :users, :keyword, :string
  end

  def down
    remove_column :users, :keyword
  end
end
