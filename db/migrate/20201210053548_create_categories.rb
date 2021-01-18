class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :industry_categories do |t|
      t.text :title
      t.text :description
      t.text :code
      t.text :slug

      t.timestamps
    end
    add_index :industry_categories, :slug, unique: true
    add_index :industry_categories, :code, unique: true


    add_column :industry_categories, :ancestry, :string
    add_index :industry_categories, :ancestry
    add_column :industry_categories, :ancestry_depth, :integer, :default => 0

    create_table :occupation_categories do |t|
      t.text :title
      t.text :description
      t.text :code
      t.text :slug

      t.timestamps
    end
    add_index :occupation_categories, :slug, unique: true
    add_index :occupation_categories, :code, unique: true


    add_column :occupation_categories, :ancestry, :string
    add_index :occupation_categories, :ancestry
    add_column :occupation_categories, :ancestry_depth, :integer, :default => 0
  end
end
