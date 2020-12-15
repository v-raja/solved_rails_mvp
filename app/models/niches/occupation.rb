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

  validates :title,       presence: true

  belongs_to :category, class_name: "OccupationCategory", foreign_key: "occupation_category_id"

  before_save :titleize_title

  has_many :occupation_posts, dependent: :destroy
  has_many :posts, through: :occupation_posts

  def titleize_title
    # title.capitalize!  # capitalize the first word in case it is part of the no words array
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
    }.join(" ") # I replaced the "end" in "end.join(" ") with "}" because it wasn't working in Ruby 2.1.1
    self.title = phrase  # returns the phrase with all the excluded words
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
