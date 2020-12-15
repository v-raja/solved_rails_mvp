class CreateMediaUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :media_urls do |t|
      t.text :url
      t.string :type
      t.integer :gallery_position
      t.references :gallery, null: false, foreign_key: true
      t.string :youtube_id
      t.timestamps
    end
    add_index :media_urls, [:gallery_id, :gallery_position]

  end
end
