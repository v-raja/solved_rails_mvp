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
    IndustryCategory.find_by(code: code).get_leaf_children.map(&:industries).flatten
  end


  private

    def should_generate_new_friendly_id?
      code_changed? || super
    end
end
