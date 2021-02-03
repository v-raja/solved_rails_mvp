class CreateSuggestedCommunities < ActiveRecord::Migration[6.0]
  def change
    create_table :suggested_communities do |t|
      t.integer :user_id
      t.text :community
      t.text :community_type
      t.timestamps
    end
    add_index :suggested_communities, :community
  end
end
