class AddIndexToCodeOnIndustries < ActiveRecord::Migration[6.0]
  def change
  end
  add_index :industries, :code, unique: true
  change_column_null :industries, :code, false
end
