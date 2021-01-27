# == Schema Information
#
# Table name: occupations
#
#  id                     :bigint           not null, primary key
#  title                  :text
#  description            :text
#  code                   :text
#  slug                   :text
#  keywords               :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  occupation_category_id :bigint           not null
#  solutions_count        :integer          default(0), not null
#  requests_count         :integer          default(0), not null
#  solution_votes_count   :integer          default(0), not null
#
class Occupation < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  acts_as_followable
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
    attribute :title, :description
    add_attribute :url, :type, :keyword_list

    searchableAttributes [ 'unordered(title)', 'unordered(keyword_list)', 'unordered(description)']
  end

  def keyword_list
    if self.keywords.present?
      self.keywords.split("; ")
    else
      []
    end
  end

  def add_keyword(keyword)
    if self.keywords.blank?
      self.keywords = keyword
    else
      self.keywords += "; #{keyword}"
    end
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

  def tags
    (self.solutions.tag_counts_on(:niche_specific_tags) + self.solutions.tag_counts_on(:general_tags)).uniq
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
