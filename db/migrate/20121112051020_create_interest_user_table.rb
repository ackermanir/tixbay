class CreateInterestUserTable < ActiveRecord::Migration
  def up
    create_table :interests_users, :id => false do |t|
      t.references :interest, :user
    end
    add_index :interests_users, [:interest_id, :user_id]
  end

  def down
    drop_table :interests_users
  end
end
