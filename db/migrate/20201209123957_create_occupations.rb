class CreateOccupations < ActiveRecord::Migration[6.0]
  def change
    create_table :occupations do |t|
      t.text :title
      t.text :description
      t.text :code
      t.text :slug
      t.text :keywords

      t.timestamps
    end
    add_index :occupations, :slug, unique: true
    add_index :occupations, :code, unique: true
  end
end
