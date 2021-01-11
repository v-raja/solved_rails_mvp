# == Schema Information
#
# Table name: occupations
#
#  id                     :integer          not null, primary key
#  title                  :string
#  description            :text
#  code                   :string           not null
#  illustrative_examples  :text
#  other_examples         :text
#  slug                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  occupation_category_id :integer          not null
#
class Occupation < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  acts_as_taggable
  validates :title,       presence: true

  belongs_to :category, class_name: "OccupationCategory", foreign_key: "occupation_category_id"

  before_save :titleize_title

  has_many :occupation_posts, dependent: :destroy
  has_many :posts, through: :occupation_posts

  has_many :occupation_requests, dependent: :destroy
  has_many :requests, through: :occupation_requests

  def titleize_title
    words_no_cap = ["and", "or", "the", "over", "to", "the", "a", "but", "of", "n.e.c.", "n.e.c", "as"]
    words_all_cap = ["It", "Hr", "r&d", "(r&d)"]
    phrase = title.titleize.split(" ").map {|word|
        if words_no_cap.include?(word.downcase)
            word.downcase
        elsif words_all_cap.include?(word)
            word.upcase
        else
            word
        end
    }.join(" ")
    self.title = phrase
  end

  def should_generate_new_friendly_id?
    title_changed? || super || true
  end

  def capitalcase_title

  end
  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :title,
      [:title, :code]
    ]
  end
end
