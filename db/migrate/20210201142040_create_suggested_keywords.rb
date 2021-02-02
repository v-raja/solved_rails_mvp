class CreateSuggestedKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :suggested_keywords do |t|
      t.text :industry_slug
      t.text :occupation_slug
      t.text :keyword
      t.integer :user_id

      t.timestamps
    end
    add_index :suggested_keywords, :industry_slug
    add_index :suggested_keywords, :occupation_slug
    add_index :suggested_keywords, :keyword
  end
end
