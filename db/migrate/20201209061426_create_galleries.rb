class CreateGalleries < ActiveRecord::Migration[6.0]
  def change
    create_table :galleries do |t|
      t.string :thumbnail_url
      t.references :post, foreign_key: true
      t.timestamps
    end
    add_reference :posts, :gallery, foreign_key: true
  end
end
