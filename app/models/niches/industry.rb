# == Schema Information
#
# Table name: industries
#
#  id                   :integer          not null, primary key
#  title                :string
#  description          :text
#  code                 :string
#  slug                 :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  industry_category_id :integer          not null
#

class Industry < ApplicationRecord

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  validates :title,       presence: true
  validates :description, presence: true

  has_many :industry_posts, dependent: :destroy
  has_many :posts, through: :industry_posts

  has_many :industry_requests, dependent: :destroy
  has_many :requests, through: :industry_requests

  acts_as_taggable

  before_save :titleize_title

  belongs_to :category, class_name: "IndustryCategory", foreign_key: "industry_category_id"

  include AlgoliaSearch

  algoliasearch index_name: 'niches', id: :code, sanitize: true, per_environment: true, raise_on_failure: Rails.env.development? do
    attribute :created_at, :title, :description

    # integer version of the created_at datetime field, to use numerical filtering
    attribute :created_at_i do
      created_at.to_i
    end

    # attribute :posts do
    #   posts.map do |p|
    #     { title: p.problem_title, url: Rails.application.routes.url_helpers.post_path(p), description: p.description, product: { name: p.product.name, thumbnail_url: p.product.thumbnail_url } }
    #   end
    # end

    add_attribute :url, :code_with_suffix, :type
    # tags tag_list
    searchableAttributes ['unordered(code_with_suffix)', 'unordered(title)', 'unordered(description)', 'type']
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
      [:title, :id]
    ]
  end

  private

  def url
    Rails.application.routes.url_helpers.industry_path(id)
  end

  def code_with_suffix
    "i/#{code}"
  end

  def type
    "Industry"
  end
end
