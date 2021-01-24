class RemoveCommonKeywordsFromOccupation < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :occupations, :common_keywords, :text }
  end
end
