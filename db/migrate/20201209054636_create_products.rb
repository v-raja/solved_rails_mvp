class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.text :name
      t.text :thumbnail_url
      t.text :slug

      t.timestamps
    end

    add_index :products, :slug, unique: true
  end
end
