# == Schema Information
#
# Table name: industry_categories
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  code        :string           not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ancestry    :string
#
class IndustryCategory < Category
  has_many :industries
end
