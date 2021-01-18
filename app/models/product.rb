# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  name       :string
#  logo_url   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  validates_presence_of :name, :logo_url
  validates :logo_url, url: { no_local: true }
  has_many :posts

  include AlgoliaSearch

  algoliasearch index_name: 'products', raise_on_failure: Rails.env.development?, sanitize: true, per_environment: true do
    attribute :created_at, :name

    add_attribute :thumbnail_url, :url, :nb_solutions

    # integer version of the created_at datetime field, to use numerical filtering
    attribute :created_at_i do
      created_at.to_i
    end

    # tags self.tag_list

    searchableAttributes ['unordered(name)']
  end

  private

  def url
    Rails.application.routes.url_helpers.product_path(id)
  end

  def thumbnail_url
    logo_url
  end

  def nb_solutions
    posts.count
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
