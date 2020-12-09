json.extract! gallery, :id, :thumbnail_url, :created_at, :updated_at
json.url gallery_url(gallery, format: :json)
