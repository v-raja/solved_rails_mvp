require 'csv'

# UK SOC 2020 Occupations


OccupationCategory.create!(
  title: "Root",
  code: "0"
).update_column(:id, 0)


csv_path = Rails.root.join('db', 'uk_soc_occupations/level1.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true)

  while row = csv.shift
    OccupationCategory.create!(
      title: row['Title'],
      code: row['Code'],
      description: row['Description'],
      tasks: row['Tasks'],
      related_job_titles: row['Related Job Titles'],
      parent: OccupationCategory.find_by(id: 0)
    ).update_column(:id, row['Code'].to_i)
  end
end

occupation_categories_csvs = %w"level2 level3"
occupation_categories_csvs.each do |csv|
  csv_path = Rails.root.join('db', "soc_occupations/#{csv}.csv")
  File.open(csv_path, 'r:ISO-8859-1') do |file|
    csv = CSV.new(file, headers: true)

    while row = csv.shift
      parent = find_occupation_category_parent(row['Code'].chop)
      if parent.nil?
        p row['Code']
      end

      OccupationCategory.create!(
        title: row['Title'],
        code: row['Code'],
        description: row['Description'],
        tasks: row['Tasks'],
        related_job_titles: row['Related Job Titles'],
        parent: parent
      ).update_column(:id, row['Code'].to_i)
    end
  end
end


csv_path = Rails.root.join('db', 'soc_occupations/level4.csv')
File.open(csv_path, 'r:ISO-8859-1') do |file|
  csv = CSV.new(file, headers: true)

  while row = csv.shift
    parent = find_occupation_category_parent(row['Code'].chop)
    if parent.nil?
      p row['Code']
    end

    Occupation.create!(
      title: row['Title'],
      code: row['Code'],
      description: row['Description'],
      tasks: row['Tasks'],
      related_job_titles: row['Related Job Titles'],
      category: parent
    ).update_column(:id, row['Code'].to_i)
  end
end
