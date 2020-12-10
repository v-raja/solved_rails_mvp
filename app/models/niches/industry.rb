# == Schema Information
#
# Table name: industries
#
#  id                   :integer          not null, primary key
#  title                :string
#  description          :text
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

  belongs_to :industry_category,
            class_name: "Category",
            foreign_key: "category_id"

  # has_many :niche_posts, dependent: :destroy
  # has_many :posts,       through: :niche_posts

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
