class CreateCategoryShowTable < ActiveRecord::Migration
  def up
    create_table :categories_shows, :id => false do |t|
      t.references :category, :show
    end
    add_index :categories_shows, [:category_id, :show_id]
  end

  def down
    drop_table :categories_shows
  end
end
