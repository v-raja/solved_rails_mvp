json.extract! product, :id, :name, :image_url, :created_at, :updated_at
json.url get_it_url(product, format: :json)
