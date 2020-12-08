# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

csv_path = Rails.root.join('db', 'niche.csv')
File.open(csv_path, 'r') do |file|
  csv = CSV.new(file, headers: true)

  while row = csv.shift
    Niche.create!(
      title: row['Title'],
      description: row['Description'],
      code: row['Code'].to_i,
      # index: row['Code'].to_i,
      slug: row['Code']
    )
  end

  # puts "Sum: #{sum}"
end
