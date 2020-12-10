class AddReferencesToIndustries < ActiveRecord::Migration[6.0]
  def change
    add_reference :industries, :category, null: false, foreign_key: true
  end
end
