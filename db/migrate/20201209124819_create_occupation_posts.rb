class CreateOccupationPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :occupation_posts do |t|
      t.integer :post_id
      t.integer :occupation_id
      t.timestamps
    end
    add_index :occupation_posts, :post_id
    add_index :occupation_posts, :occupation_id
    add_index :occupation_posts, [:post_id, :occupation_id], unique: true
  end
end
