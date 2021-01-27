class AddCountToIndustries < ActiveRecord::Migration[6.0]
  def change
    add_column :industries, :solutions_count, :integer, null: false, default: 0
    add_column :industries, :requests_count, :integer, null: false, default: 0
  end
end
