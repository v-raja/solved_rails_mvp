class RemoveCommonKeywordsFromIndustry < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :industries, :common_keywords, :text }
  end
end
