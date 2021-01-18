class CreateYoutubeUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :youtube_urls do |t|
      t.text :url
      t.references :solution, null: false, foreign_key: true
      t.text :youtube_id
      t.timestamps
    end
  end
end
