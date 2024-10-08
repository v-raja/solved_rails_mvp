# == Schema Information
#
# Table name: occupation_categories
#
#  id             :bigint           not null, primary key
#  title          :text
#  description    :text
#  code           :text
#  slug           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#
class OccupationCategory < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_ancestry cache_depth: true

  validates :title,       presence: true
  has_many :occupations

  before_save :titleize_title

  # gets all leaf occupation categories (including self)
  def get_leaf_children
    subtree.where(ancestry_depth: 3)
  end

  def self.get_occupations(code)
    if oc = OccupationCategory.find_by(code: code)
      return oc.get_leaf_children.map(&:occupations).flatten
    else
      return []
    end
  end


  def self.get_occupations_from_string(code_string)
    occupations = []
    code_string.split(", ").each do |niche_code|
      if niche_code[-1] != '0' then
        occupations.concat Occupation.where(code: niche_code)
      else
        occupations.concat OccupationCategory.get_occupations(niche_code)
      end
    end
    occupations.uniq!
    return occupations
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
