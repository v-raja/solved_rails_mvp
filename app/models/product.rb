# == Schema Information
#
# Table name: products
#
#  id            :bigint           not null, primary key
#  name          :text
#  thumbnail_url :text
#  slug          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  validates_presence_of :name, :thumbnail_url
  validates :thumbnail_url, url: { no_local: true }
  has_many :solutions

  include AlgoliaSearch

  algoliasearch index_name: 'products', raise_on_failure: Rails.env.development?, sanitize: true, per_environment: true do
    attribute :created_at, :name, :thumbnail_url

    add_attribute :url, :nb_solutions

    # integer version of the created_at datetime field, to use numerical filtering
    attribute :created_at_i do
      created_at.to_i
    end

    # tags self.tag_list

    searchableAttributes ['unordered(name)']
  end

  private

  def url
    Rails.application.routes.url_helpers.product_path(self.slug)
  end

  def nb_solutions
    solutions.count
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :name,
      [:name, :id]
    ]
  end
end
