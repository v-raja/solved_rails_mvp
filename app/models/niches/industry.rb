# == Schema Information
#
# Table name: industries
#
#  id                   :integer          not null, primary key
#  title                :string
#  description          :text
#  code                 :string
#  slug                 :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  industry_category_id :integer          not null
#
class Industry < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  validates :title,       presence: true
  validates :description, presence: true

  has_many :industry_posts, dependent: :destroy
  has_many :posts, through: :industry_posts

  acts_as_taggable

  before_save :titleize_title

  belongs_to :category, class_name: "IndustryCategory", foreign_key: "industry_category_id"

  def titleize_title
    words_no_cap = ["and", "or", "the", "over", "to", "the", "a", "but", "of"]
    self.title = title.titleize(exclusions: words_no_cap)
  end

  def should_generate_new_friendly_id?
    title_changed? || super || true
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end
end
