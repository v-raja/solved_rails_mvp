class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :problem_title
      t.string :tagline
      t.text :description
      t.string :product_url
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
