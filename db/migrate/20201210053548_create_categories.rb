class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :industry_categories do |t|
      t.string :title
      t.text :description
      t.string :code
      t.string :slug
      t.string :type

      t.timestamps
    end
    change_column_null :industry_categories, :slug, false
    change_column_null :industry_categories, :code, false
    add_index :industry_categories, [:slug, :type], unique: true


    add_column :industry_categories, :ancestry, :string
    add_index :industry_categories, :ancestry
    add_column :industry_categories, :ancestry_depth, :integer, :default => 0

    create_table :occupation_categories do |t|
      t.string :title
      t.text :description
      t.text :illustrative_examples
      t.text :other_examples
      t.string :code
      t.string :slug
      t.string :type

      t.timestamps
    end
    change_column_null :occupation_categories, :slug, false
    change_column_null :occupation_categories, :code, false
    add_index :occupation_categories, [:slug, :type], unique: true


    add_column :occupation_categories, :ancestry, :string
    add_index :occupation_categories, :ancestry
    add_column :occupation_categories, :ancestry_depth, :integer, :default => 0
  end
end
