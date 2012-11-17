class CreateCategoryUserTable < ActiveRecord::Migration
  def up
    create_table :categories_users, :id => false do |t|
      t.references :category, :user
    end
    add_index :categories_users, [:category_id, :user_id]
  end

  def down
    drop_table :categories_users
  end
end
