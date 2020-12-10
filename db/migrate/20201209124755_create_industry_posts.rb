class CreateIndustryPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :industry_posts do |t|
      t.integer :post_id
      t.integer :industry_id
      t.timestamps
    end
    add_index :industry_posts, :post_id
    add_index :industry_posts, :industry_id
    add_index :industry_posts, [:post_id, :industry_id], unique: true
  end
end
