class AddUserSuggestedKeywordsToIndustries < ActiveRecord::Migration[6.0]
  def change
    add_column :industries, :user_suggested_keywords, :text
  end
end
