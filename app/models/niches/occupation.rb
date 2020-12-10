# == Schema Information
#
# Table name: occupations
#
#  id                     :integer          not null, primary key
#  title                  :string
#  description            :text
#  code                   :integer          not null
#  slug                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  occupation_category_id :integer          not null
#
class Occupation < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  validates :title,       presence: true

  belongs_to :occupation_category,
            class_name: 'Category',
            foreign_key: "category_id"

  has_many :occupation_posts, dependent: :destroy
  has_many :posts, through: :occupation_posts

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
