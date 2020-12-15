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

  extend FriendlyId
  friendly_id :code, use: :scoped, scope: :type

  validates :title,       presence: true
  has_many :occupations

  before_save :titleize_title

  private

    def should_generate_new_friendly_id?
      title_changed? || super || true
    end


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
end
