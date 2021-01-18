# == Schema Information
#
# Table name: industry_categories
#
#  id             :integer          not null, primary key
#  title          :string
#  description    :text
#  code           :string           not null
#  slug           :string           not null
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#
class IndustryCategory < ApplicationRecord
  has_ancestry cache_depth: true

  validates :title,        presence: true
  has_many  :industries

  extend FriendlyId
  friendly_id :code, use: :scoped, scope: :type

  # gets all leaf industry categories (including self)
  def get_leaf_children
    subtree.where(ancestry_depth: 5)
  end

  def self.get_industries(code)
    if ic = IndustryCategory.find_by(code: code)
      return ic.get_leaf_children.map(&:industries).flatten
    else
      return []
    end
  end

  def self.get_industries_from_string(code_string)
    industries = []
    code_string.split(", ").each do |niche_code|
      if niche_code.length == 6 then
        industries.concat Industry.where(id: niche_code)
      else
        industries.concat IndustryCategory.get_industries(niche_code)
      end
    end
    industries.uniq!
    return industries
  end


  private

    def should_generate_new_friendly_id?
      code_changed? || super
    end
end
