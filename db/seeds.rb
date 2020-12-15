require 'csv'

industries  = true
occupations = true

INDUSTRIES_CSV = Rails.root.join('db', 'seeds', '001_industries.rb')
OCCUPATIONS_CSV = Rails.root.join('db', 'seeds', '002_na_soc_occupations.rb')
if industries then
  puts "Processing #{INDUSTRIES_CSV}"
  require INDUSTRIES_CSV
end
if occupations then
  puts "Processing #{OCCUPATIONS_CSV}"
  require OCCUPATIONS_CSV
end



key = "1TojymXVXDJozEVyzy4qkkFk56n2wsryX6C1WpOEr5hk"
link = "https://docs.google.com/spreadsheets/d/#{key}/gviz/tq?tqx=out:csv&sheet="

sheet = "youtube_urls"
youtube_urls_path = Rails.root.join("db", "data", sheet + ".csv")
`wget -O "#{youtube_urls_path}" "#{link + sheet}"`

def get_youtube_urls_where_product_id(id, youtube_urls_path)
  rows = []
  CSV.foreach(youtube_urls_path, headers: true) do |row|
    if row["product_id"] == id then
      rows << row
    end
  end
  rows
end

# def get_media_urls_where_gallery_id(id, media_urls_path)
#   rows = []
#   CSV.foreach(media_urls_path, headers: true) do |row|
#     if row["gallery_id"] == id then
#       rows << row
#     end
#   end
#   rows
# end

def get_industries(code)
  industries = []
  if code.length == 5 then
    industries = IndustryCategory.find_by(code: code).industries
  elsif code.length < 5 then
    # The depth of the leaf industry category nodes
    ancestry_depth = 5 - code.length
    industry_categories = IndustryCategory.find_by(code: code).descendants(at_depth: ancestry_depth)
    industry_categories.each do |ic|
      industries << ic.industries
    end
  else
    industries = Industry.where(id: code)
  end
  industries
end

def get_occupations(code)
  occupations = []
  if code[-1] == '0' then
    occupations = OccupationCategory.find_by(code: code).descendants(at_depth: 3)
  else
    occupations = Occupation.where(code: code)
  end
  occupations
end

sheets = %w"products posts"
sheets.each do |sheet|
  csv_path = Rails.root.join("db", "data", sheet + ".csv")
  `wget -O "#{csv_path}" "#{link + sheet}"`
  if sheet == "products" then
    CSV.foreach(csv_path, headers: true) do |row|
      p "product"
      p row
      Product.find_or_create_by(
        name: row["name"],
        logo_url: row["logo_url"]
      ).update_column(:id, row["id"])
    end
  elsif sheet == "posts" then
    CSV.foreach(csv_path, headers: true) do |row|
      p row
      post = Post.find_or_create_by(
        product_id: row["product_id"],
        product_url: row["product_url"],
        description: row["description"],
        problem_title: row["problem_title"],
      )
      post.save!

      youtube_urls_rows = get_youtube_urls_where_product_id(row["id"],
                                                            youtube_urls_path)

      youtube_urls_rows.each do |row|
        post.youtube_urls.create!(
          url: row["url"]
        )
      end

      row["industry_ids"].split(", ").each do |id|
        industries = get_industries(id)
        p industries
        industries.each do |industry|
          post.post_to_industry(industry)
        end
      end

      row["occupation_ids"].split(", ").each do |id|
        occupations = get_occupations(id)
        occupations.each do |occupation|
          post.post_to_occupation(occupation)
        end
      end
    end
  end
end
