class AddCountToOccupations < ActiveRecord::Migration[6.0]
  def change
    add_column :occupations, :solutions_count, :integer, null: false, default: 0
    add_column :occupations, :requests_count, :integer, null: false, default: 0
  end
end
