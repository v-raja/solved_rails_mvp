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
    email: "vivek.r.raja@gmail.com",
    admin: true,
    password: "password",
    password_confirmation: "password",
    confirmed_at: Time.zone.now
  )
else
  vivek = User.first
end

# sheet = "youtube_urls"
# youtube_urls_path = Rails.root.join("db", "data", sheet + ".csv")
# `wget -O "#{youtube_urls_path}" "#{link + sheet}"`

# def get_youtube_urls_where_product_id(id, youtube_urls_path)
#   rows = []
#   CSV.foreach(youtube_urls_path, headers: true) do |row|
#     if row["product_id"] == id then
#       rows << row
#     end
#   end
#   rows
# end


# sheets = %w"products solutions"

# sheets.each do |sheet|
#   csv_path = Rails.root.join("db", "data", sheet + ".csv")
#   `wget -O "#{csv_path}" "#{link + sheet}"`
#   if sheet == "products" then
#     CSV.foreach(csv_path, headers: true) do |row|
#       Product.find_or_create_by(
#         name: row["name"],
#         thumbnail_url: row["thumbnail_url"]
#       ).update_column(:id, row["id"])
#     end
#   elsif sheet == "solutions" then
#     CSV.foreach(csv_path, headers: true) do |row|
#       solution = vivek.solutions.build(
#         product_id: row["product_id"],
#         get_it_url: row["get_it_url"],
#         description: row["description"],
#         title: row["title"],
#       )
#       solution.general_tag_list = row["general_tag_list"]

#       youtube_urls_rows = get_youtube_urls_where_product_id(row["id"],
#                                                             youtube_urls_path)
#       youtube_urls_rows.each do |row|
#         solution.youtube_urls.build(
#           url: row["url"]
#         )
      # end


#       industries = IndustryCategory.get_industries_from_string(row["industry_ids"])
#       industries.each do |industry|
#         solution.post_to_industry(industry)
#       end

#       occupations = OccupationCategory.get_occupations_from_string(row["occupation_ids"])
#       occupations.each do |occupation|
#         solution.post_to_occupation(occupation)
#       end

#       if industries.count != row["i_count"].to_i
#         p "#{industries.count} industries"
#         p row["industry_ids"]
#         p solution
#       end

#       if occupations.count != row["o_count"].to_i
#         p "#{occupations.count} occupations"
#         p solution
#       end

#       solution.save!
#     end
#   elsif sheet == "requests" then
#     CSV.foreach(csv_path, headers: true) do |row|
#       request = vivek.requests.build(
#         title: row["title"],
#         description: row["description"],
#       )
#       industries = IndustryCategory.get_industries_from_string(row["industry_ids"])
#       industries.each do |industry|
#         request.post_to_industry(industry)
#       end

#       occupations = OccupationCategory.get_occupations_from_string(row["occupation_ids"])
#       occupations.each do |occupation|
#         request.post_to_occupation(occupation)
#       end

#       request.save!
#     end
#   end
# end

csv_path = Rails.root.join('db', 'industry_categories/naics_keywords.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true, liberal_parsing: true)
  while row = csv.shift
    # p row
    # byebug

    niche = Industry.find_by(code: row['code'])
    niche.add_keyword(row['keyword'])
    niche.save!
  end
end

csv_path = Rails.root.join('db', 'na_soc_2018/na_soc_2018_keywords.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true, liberal_parsing: true)
  while row = csv.shift
    # p row
    niche = Occupation.find_by(code: row[0])
    niche.add_keyword(row['keyword'])
    niche.save!
  end
end
