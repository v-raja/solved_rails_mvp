class CreateIndustries < ActiveRecord::Migration[6.0]
  def change
    create_table :industries do |t|
      t.text :title
      t.text :description
      t.text :code
      t.text :slug
      t.text :keywords

      t.timestamps
    end
    add_index :industries, :slug, unique: true
    add_index :industries, :code, unique: true
  end
end
