class CreateSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :solutions do |t|
      t.text :title
      t.text :description
      t.text :description_safe_html
      t.text :get_it_url
      t.references :product, null: false, foreign_key: true
      t.text :slug

      t.timestamps
    end

    add_index :solutions, :slug, unique: true
  end
end
