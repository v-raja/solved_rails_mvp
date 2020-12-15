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

  extend FriendlyId
  friendly_id :code, use: :scoped, scope: :type

  validates :title,        presence: true
  has_many  :industries

  private

    def should_generate_new_friendly_id?
      title_changed? || super || true
    end
end
