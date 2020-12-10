class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :title
      t.text :description
      t.string :code
      t.string :slug
      t.string :type

      t.timestamps
    end
    change_column_null :categories, :slug, false
    change_column_null :categories, :code, false
    add_index :categories, [:slug, :type], :unique => true, :name => 'by_slug_and_type'


    add_column :categories, :ancestry, :string
    add_index :categories, :ancestry
  end
end
