require 'csv'

def find_industry_category_parent(code)
  # p code
  parent = nil
  while parent.nil?
    if code.in?(%w"31 32 33")
      code = "31-33"
    elsif code.in?(%w"44 45")
      code = "44-45"
    elsif code.in?(%w"48 49")
      code = "48-49"
    end
    parent = IndustryCategory.find_by(code: code)
    code.chop!
  end
  parent
end

csv_path = Rails.root.join('db', 'industry_categories/group.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true, liberal_parsing: true)
  while row = csv.shift
    IndustryCategory.create!(
      title: row['Title'],
      code: row['Code']
    )
  end
end

csv_path = Rails.root.join('db', 'industry_categories/supersector.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true, liberal_parsing: true)
  while row = csv.shift
    p row['Code']
    IndustryCategory.create!(
      title: row['Title'],
      code: row['Code'],
      parent: IndustryCategory.find(row['Parent'])
    )
  end
end

csv_path = Rails.root.join('db', 'industry_categories/sector.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true, liberal_parsing: true)
  while row = csv.shift

    IndustryCategory.create!(
      title: row['Title'],
      description: row['Description'],
      code: row['Code'],
      parent: IndustryCategory.find_by(code: row['Parent'])
    )
  end
end

industry_categories_csvs = %w"subsector industry_group industry"
industry_categories_csvs.each do |csv|
  p csv
  csv_path = Rails.root.join('db', "industry_categories/#{csv}.csv")
  File.open(csv_path, 'r') do |file|
    csv = CSV.new(file, headers: true)
    while row = csv.shift
      parent = find_industry_category_parent(row['Code'].chop)
      if parent.nil?
        p row['Code']
      end

      IndustryCategory.create!(
        title: row['Title'],
        description: row['Description'],
        code: row['Code'],
        parent: parent
      )
    end
  end
end


csv_path = Rails.root.join('db', 'industry_categories/industries.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true)
  while row = csv.shift
    parent = find_industry_category_parent(row['Code'].chop)
    if parent.nil?
      p row['Code']
    end

    # p parent

    industry = Industry.new(
      title: row['Title'],
      description: row['Description'],
      code: row['Code'],
      category: parent
    )
    # industry.id = row['Code'].to_i
    industry.save!
  end
end
