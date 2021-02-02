class AddUserSuggestedKeywordsToOccupations < ActiveRecord::Migration[6.0]
  def change
    add_column :occupations, :user_suggested_keywords, :text
  end
end
