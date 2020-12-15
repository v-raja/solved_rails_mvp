require 'csv'

# NA SOC 2018 Occupations

def set_first_letter_to_zero(str)
  str[0] = '0'
  str
end

def find_na_soc_parent(code)
  code = code.gsub(/-/,'')
  parent = nil
  while parent.nil?
    code = code.gsub(/[1-9](0)*$/) {
      set_first_letter_to_zero(Regexp.last_match[0])
    }
    parent = OccupationCategory.find_by(id: code)
  end
  parent
end

OccupationCategory.create!(
  title: "Root",
  code: "0"
).update_column(:id, 0)


csv_path = Rails.root.join('db', 'na_soc_2018/level1.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true)

  while row = csv.shift
    OccupationCategory.create!(
      title: row['Title'],
      code: row['Code'],
      description: row['Description'],
      parent: OccupationCategory.find_by(id: 0)
    ).update_column(:id, row['Code'].gsub(/-/,'').to_i)
  end
end

occupation_categories_csvs = %w"level2 level3"
occupation_categories_csvs.each do |csv|
  csv_path = Rails.root.join('db', "na_soc_2018/#{csv}.csv")
  File.open(csv_path, 'r') do |file|
    csv = CSV.new(file, headers: true)

    while row = csv.shift
      parent = find_na_soc_parent(row['Code'])
      if parent.nil?
        p "Parent is nil"
        p row['Code']
      end
      # p parent
      OccupationCategory.create!(
        title: row['Title'],
        code: row['Code'],
        description: row['Description'],
        parent: parent
      ).update_column(:id, row['Code'].gsub(/-/,'').to_i)
    end
  end
end


csv_path = Rails.root.join('db', 'na_soc_2018/level4.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true)

  while row = csv.shift
    parent = find_na_soc_parent(row['Code'])
    if parent.nil?
      p row['Code']
    end

    Occupation.create!(
      title: row['Title'],
      code: row['Code'],
      description: row['Description'],
      category: parent
    ).update_column(:id, row['Code'].gsub(/-/,'').to_i)
  end
end
