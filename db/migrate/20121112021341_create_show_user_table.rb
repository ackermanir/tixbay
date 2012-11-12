class CreateShowUserTable < ActiveRecord::Migration
  def up
    create_table :shows_users, :id => false do |t|
      t.references :show, :user
    end
    add_index :shows_users, [:show_id, :user_id]
  end

  def down
    drop_table :shows_users
  end
end
