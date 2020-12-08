class AddIndexToCodesForNiches < ActiveRecord::Migration[6.0]
  def change
    add_index :niches, :code, :unique => true
    change_column_null :niches, :code, false
  end
end
