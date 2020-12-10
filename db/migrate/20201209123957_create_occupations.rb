class CreateOccupations < ActiveRecord::Migration[6.0]
  def change
    create_table :occupations do |t|
      t.string :title
      t.text :description
      t.integer :code
      t.string :slug

      t.timestamps
    end
    add_index :occupations, :slug, unique: true
    change_column_null :occupations, :slug, false
    add_index :occupations, :code, :unique => true
    change_column_null :occupations, :code, false
  end
end
