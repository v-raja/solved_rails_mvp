require 'csv'

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


sheets = %w"products solutions"

sheets.each do |sheet|
  csv_path = Rails.root.join("db", "data", sheet + ".csv")
  `wget -O "#{csv_path}" "#{link + sheet}"`
  if sheet == "products" then
    CSV.foreach(csv_path, headers: true) do |row|
      Product.find_or_create_by(
        name: row["name"],
        thumbnail_url: row["thumbnail_url"]
      ).update_column(:id, row["id"])
    end
  elsif sheet == "solutions" then
    CSV.foreach(csv_path, headers: true) do |row|
      p row
      p row["niche_list"].split(", ")
      solution = User.first.solutions.build(
        product_id: row["product_id"],
        get_it_url: row["get_it_url"],
        description: row["description"],
        title: row["title"],
        niche_specific_tag_list: row["niche_tag_list"],
        general_tag_list: row["general_tag_list"],
        niche_list: row["niche_list"].split(", ")
      )

      youtube_urls_rows = get_youtube_urls_where_product_id(row["id"],
                                                            youtube_urls_path)
      youtube_urls_rows.each do |row|
        solution.youtube_urls.build(
          url: row["url"]
        )
      end

      solution.save!
    end
  end
end
