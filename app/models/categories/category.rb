class Category < ApplicationRecord
  has_ancestry

  extend FriendlyId
  friendly_id :code, use: :scoped, scope: :type

  validates :title,       presence: true

  has_many :industries

  def should_generate_new_friendly_id?
    title_changed? || super || true
  end
end
