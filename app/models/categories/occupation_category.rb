# == Schema Information
#
# Table name: occupation_categories
#
#  id                    :integer          not null, primary key
#  title                 :string
#  description           :text
#  illustrative_examples :text
#  other_examples        :text
#  code                  :string           not null
#  slug                  :string           not null
#  type                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  ancestry              :string
#  ancestry_depth        :integer          default(0)
#
class OccupationCategory < ApplicationRecord
  has_ancestry cache_depth: true

  validates :title,       presence: true
  has_many :occupations

  before_save :titleize_title

  extend FriendlyId
  friendly_id :code, use: :scoped, scope: :type

  # gets all leaf occupation categories (including self)
  def get_leaf_children
    subtree.where(ancestry_depth: 3)
  end

  def self.get_occupations(code)
    OccupationCategory.find_by(code: code).get_leaf_children.map(&:occupations).flatten
  end

  private

    def should_generate_new_friendly_id?
      code_changed? || super
    end


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
end
