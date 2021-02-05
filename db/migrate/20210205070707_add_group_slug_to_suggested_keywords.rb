class AddGroupSlugToSuggestedKeywords < ActiveRecord::Migration[6.0]
  def change
    add_column :suggested_keywords, :group_slug, :text
    add_index :suggested_keywords, :group_slug
  end
end
