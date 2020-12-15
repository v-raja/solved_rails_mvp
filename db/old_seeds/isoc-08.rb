require 'csv'

def find_occupation_category_parent(code)
  p code
  parent = nil
  while parent.nil?
    parent = OccupationCategory.find_by(id: code)
    code.chop!
  end
  parent
end

OccupationCategory.create!(
  title: "Root",
  code: "0"
).update_column(:id, 0)


csv_path = Rails.root.join('db', 'occupations/level1.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true)

  while row = csv.shift
    p row
    OccupationCategory.create!(
      title: row['Title'],
      code: row['Code'],
      parent: OccupationCategory.find_by(id: 0)
    ).update_column(:id, row['Code'].to_i)
  end
end

occupation_categories_csvs = %w"level2 level3"
occupation_categories_csvs.each do |csv|
  csv_path = Rails.root.join('db', "occupations/#{csv}.csv")
  File.open(csv_path, 'r') do |file|
    csv = CSV.new(file, headers: true)

    while row = csv.shift
      parent = find_occupation_category_parent(row['Code'].chop)
      if parent.nil?
        p row['Code']
      end

      OccupationCategory.create!(
        title: row['Title'],
        code: row['Code'],
        parent: parent
      ).update_column(:id, row['Code'].to_i)
    end
  end
end



csv_path = Rails.root.join('db', 'occupations/occupations.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true)

  while row = csv.shift
    parent = find_occupation_category_parent(row['Code'].chop)
    if parent.nil?
      p row['Code']
    end

    Occupation.create!(
      title: row['Title'],
      code: row['Code'],
      category: parent
    ).update_column(:id, row['Code'].to_i)
  end
end
