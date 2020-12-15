class CreateIndustries < ActiveRecord::Migration[6.0]
  def change
    create_table :industries do |t|
      t.string :title
      t.text :description
      t.string :code
      t.string :slug

      t.timestamps
    end
    add_index :industries, :slug, unique: true
    change_column_null :industries, :slug, false
  end
end
