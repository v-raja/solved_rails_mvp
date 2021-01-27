# == Schema Information
#
# Table name: industries
#
#  id                   :bigint           not null, primary key
#  title                :text
#  description          :text
#  code                 :text
#  slug                 :text
#  keywords             :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  industry_category_id :bigint           not null
#  solutions_count      :integer          default(0), not null
#  requests_count       :integer          default(0), not null
#  solution_votes_count :integer          default(0), not null
#

class Industry < ApplicationRecord

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  validates :title,       presence: true
  validates :description, presence: true

  has_many :industry_solutions, dependent: :destroy
  has_many :solutions, through: :industry_solutions

  has_many :industry_requests, dependent: :destroy
  has_many :requests, through: :industry_requests

  acts_as_followable

  before_save :titleize_title

  belongs_to :category, class_name: "IndustryCategory", foreign_key: "industry_category_id"

  include AlgoliaSearch

  algoliasearch index_name: 'niches', id: :code, sanitize: true, raise_on_failure: Rails.env.development?, per_environment: true do
    attribute :title, :description
    add_attribute :url, :type, :keyword_list

    searchableAttributes [ 'unordered(title)', 'unordered(keyword_list)', 'unordered(description)']
  end

  def titleize_title
    words_no_cap = ["and", "or", "the", "over", "to", "the", "a", "but", "of"]
    self.title = title.titleize(exclusions: words_no_cap)
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

  def tags
    (self.solutions.tag_counts_on(:niche_specific_tags) + self.solutions.tag_counts_on(:general_tags)).uniq
  end

  def keyword_list
    if self.keywords
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

  private

  def url
    Rails.application.routes.url_helpers.industry_path(slug)
  end

  def url_changed?
    slug_changed?
  end

  def keyword_list_changed?
    keywords_changed?
  end

  def code_with_suffix
    "i/#{code}"
  end

  def type
    "Industry"
  end

end
