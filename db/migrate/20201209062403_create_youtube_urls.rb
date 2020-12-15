class CreateYoutubeUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :youtube_urls do |t|
      t.text :url
      t.references :post, null: false, foreign_key: true
      t.string :youtube_id
      t.timestamps
    end
  end
end
