# == Schema Information
#
# Table name: niches
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  code        :integer          not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Niche < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  validates :title,       presence: true
  validates :description, presence:true
  validates :code,        presence: true,
                          numericality: { only_integer: true,
                                          greater_than_or_equal_to: 100000,
                                          less_than_or_equal_to:    999999 }

  has_many :niche_posts, dependent: :destroy
  has_many :posts, through: :niche_posts

  def should_generate_new_friendly_id?
    title_changed? || super || true
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :code,
      :title,
      [:title, :code]
    ]
  end
end
