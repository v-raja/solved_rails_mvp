require 'csv'

key = "1TojymXVXDJozEVyzy4qkkFk56n2wsryX6C1WpOEr5hk"
link = "https://docs.google.com/spreadsheets/d/#{key}/gviz/tq?tqx=out:csv&sheet="

all = true
industries  = all
occupations = all
create_vivek = all

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

vivek = nil
if create_vivek
  vivek = User.create!(
    name: "Vivek Raja",
    email: "vivek@gmail.com",
    role: "Customer Success",
    company: "Acme Inc.",
    pseudonym: Faker::Name.unique.name,
    fake_company: "Googol",
    admin: true,
    thumbnail_url: "https://pbs.twimg.com/profile_images/887661330832003072/Zp6rA_e2_400x400.jpg",
    password: "password",
    password_confirmation: "password",
    confirmed_at: Time.zone.now
  )
else
  vivek = User.first
end

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
  industries = Industry.none
  if code.length == 5 then
    industries = IndustryCategory.find_by(code: code).industries
  elsif code.length < 5 then
    # The depth of the leaf industry category nodes
    ancestry_depth = 5 - code.length
    industry_categories = IndustryCategory.find_by(code: code).descendants(at_depth: ancestry_depth)
    industry_categories.each do |ic|
      industries.merge(ic.industries)
      # ic.industries.each do |industry|
      #   industries.merge(industry)
      # end
    end
  else
    industries = Industry.where(id: code)
  end
  industries
end

def count_end_zeros(id_s)
  idx = -1
  while id_s[idx] == '0'
    idx = idx - 1
  end
  return (idx + 1) * -1
end

def get_occupations(id_s)
  occupations = Occupation.none
  if id_s[-1] == '0' then
    occupation_categories = OccupationCategory.find(id_s).descendants.where(ancestry_depth: 3)
    occupation_categories.each do |oc|
      oc.occupations.each do |occupation|
        occupations.merge(occupation)
      end
    end
  else
    occupations = Occupation.where(id: id_s)
  end
  occupations
end

sheets = %w"products posts requests"
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
      post = vivek.posts.find_or_create_by(
        product_id: row["product_id"],
        product_url: row["product_url"],
        description: row["description"],
        problem_title: row["problem_title"],
      )
      post.tag_list = row["tags"]
      post.save!

      youtube_urls_rows = get_youtube_urls_where_product_id(row["id"],
                                                            youtube_urls_path)

      youtube_urls_rows.each do |row|
        post.youtube_urls.find_or_create_by(
          url: row["url"]
        )
      end


      industries = []
      row["industry_ids"].split(", ").each do |niche_code|
        if niche_code.length == 6 then
          industries.concat Industry.where(id: niche_code)
        else
          industries.concat IndustryCategory.get_industries(niche_code)
        end
      end
      industries.uniq!

      industries.each do |industry|
        industry.tag_list.add(row["tags"], parse: true)
        industry.save!
        industry.reload
        post.post_to_industry(industry)
      end

      occupations = []
      row["occupation_ids"].split(", ").each do |niche_code|
        if niche_code[-1] != '0' then
          occupations.concat Occupation.where(code: niche_code)
        else
          occupations.concat OccupationCategory.get_occupations(niche_code)
        end
      end
      occupations.uniq!

      occupations.each do |occupation|
        occupation.tag_list.add(row["tags"], parse: true)
        occupation.save!
        occupation.reload
        post.post_to_occupation(occupation)
      end
    end
  elsif sheet == "requests" then
    CSV.foreach(csv_path, headers: true) do |row|
      request = vivek.requests.find_or_create_by(
        title: row["title"],
        description: row["description"],
      )
      request.save!

      industries = IndustryCategory.get_industries_from_string(row["industry_ids"])
      industries.each do |industry|
        request.post_to_industry(industry)
      end

      occupations = OccupationCategory.get_occupations_from_string(row["occupation_ids"])
      occupations.each do |occupation|
        request.post_to_occupation(occupation)
      end
    end
  end
end
