class AddReferencesToIndustries < ActiveRecord::Migration[6.0]
  def change
    add_reference :industries, :industry_category, null: false, foreign_key: true
  end
end
