# == Schema Information
#
# Table name: occupations
#
#  id                     :bigint           not null, primary key
#  title                  :text
#  description            :text
#  code                   :text
#  slug                   :text
#  common_keywords        :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  occupation_category_id :bigint           not null
#
class Occupation < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  acts_as_taggable
  validates :title,       presence: true
  validates :description, presence: true

  belongs_to :category, class_name: "OccupationCategory", foreign_key: "occupation_category_id"

  before_save :titleize_title

  has_many :occupation_solutions, dependent: :destroy
  has_many :solutions, through: :occupation_solutions

  has_many :occupation_requests, dependent: :destroy
  has_many :requests, through: :occupation_requests


  include AlgoliaSearch

  algoliasearch index_name: 'niches', id: :code, raise_on_failure: Rails.env.development?, sanitize: true, per_environment: true do
    attribute :created_at, :title, :description

    add_attribute :url, :code_with_suffix, :type

    # integer version of the created_at datetime field, to use numerical filtering
    attribute :created_at_i do
      created_at.to_i
    end

    # tags self.tag_list

    searchableAttributes ['unordered(code_with_suffix)', 'unordered(title)', 'unordered(description)', 'type']
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

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :title,
      [:title, :code]
    ]
  end

  private

  def code_with_suffix
    "o/#{code}"
  end

  def url
    Rails.application.routes.url_helpers.occupation_path(slug)
  end

  def type
    "Occupation"
  end
end
