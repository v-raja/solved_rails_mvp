json.extract! post, :id, :problem_title, :tagline, :description, :youtube_url, :product_url, :created_at, :updated_at
json.url post_url(post, format: :json)
