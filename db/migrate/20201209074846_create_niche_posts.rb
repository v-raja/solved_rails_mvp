class CreateNichePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :niche_posts do |t|
      t.integer :post_id
      t.integer :niche_id
      t.timestamps
    end
    add_index :niche_posts, :post_id
    add_index :niche_posts, :niche_id
    add_index :niche_posts, [:post_id, :niche_id], unique: true
  end
end
