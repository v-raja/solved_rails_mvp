class AddIndexToNiches < ActiveRecord::Migration[6.0]
  def change
    add_index :niches, :slug, :unique => true
    change_column_null :niches, :slug, false

  end
end
