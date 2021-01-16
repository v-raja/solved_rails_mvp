# == Schema Information
#
# Table name: posts
#
#  id            :integer          not null, primary key
#  problem_title :string
#  tagline       :string
#  description   :text
#  product_url   :string
#  product_id    :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
class Post < ApplicationRecord
  validates_presence_of :problem_title, :description, :youtube_urls, :product

  has_many :industry_posts, dependent: :destroy
  has_many :industries, through: :industry_posts

  has_many :occupation_posts, dependent: :destroy
  has_many :occupations, through: :occupation_posts

  has_many :youtube_urls, dependent: :destroy
  accepts_nested_attributes_for :youtube_urls, allow_destroy: true, reject_if: proc { |att| att['url'].blank? }

  belongs_to :product
  accepts_nested_attributes_for :product, :reject_if => :check_if_product_exists

  # validates_presence_of :product_id, :unless => "product.present?"
  validates_associated :product
  validates :product_url, url: { no_local: true }

  belongs_to :user

  # default_scope { order(created_at: :desc) }

  acts_as_commentable
  acts_as_votable cacheable_strategy: :update_columns
  acts_as_taggable

  scope :today,      -> { where('DATE(posts.created_at) = ?', Date.today) }
  scope :past_week,  -> { where("posts.created_at >= :start_date AND posts.created_at < :end_date", {:start_date => 1.week.ago, :end_date => Date.today }) }
  scope :past_month, -> { where("posts.created_at >= :start_date AND posts.created_at < :end_date", {:start_date => 1.month.ago, :end_date => 1.week.ago }) }

  scope :today_ordered_by_votes, -> { where('DATE(posts.created_at) = ?', Date.today).order(cached_votes_score: :desc) }
  scope :past_week_ordered_by_votes,  -> { where("posts.created_at >= :start_date AND posts.created_at < :end_date", {:start_date => 1.week.ago, :end_date => Date.today }).order(cached_votes_score: :desc) }
  scope :past_month_ordered_by_votes, -> { where("posts.created_at >= :start_date AND posts.created_at < :end_date", {:start_date => 1.month.ago, :end_date => 1.week.ago }).order(cached_votes_score: :desc) }

  include AlgoliaSearch

  algoliasearch index_name: 'posts', sanitize: true, per_environment: true, raise_on_failure: Rails.env.development? do
    attribute :created_at, :problem_title, :description

    # integer version of the created_at datetime field, to use numerical filtering
    attribute :created_at_i do
      created_at.to_i
    end

    attribute :user do
      { name: user.name }
    end

    attribute :product do
      { name: product.name, thumbnail_url: product.logo_url, url: Rails.application.routes.url_helpers.product_path(product) }
    end

    attribute :industries do
      industries.map do |i|
        { title: i.title, url: Rails.application.routes.url_helpers.industry_path(i), type: "Industry" }
      end
    end

    attribute :occupations do
      occupations.map do |o|
        { title: o.title, url: Rails.application.routes.url_helpers.occupation_path(o), type: "Occupation" }
      end
    end

    # tags tag_list

    searchableAttributes ['unordered(problem_title)', 'unordered(description)']
  end

  def post_to_industry(industry)
    industries << industry
  end

  def post_to_occupation(occupation)
    occupations << occupation
  end

  private

  def check_if_product_exists(product_attr)
    # User has selected an existing product so both fields are blank
    if product_attr['name'].blank? && product_attr['thumbnail_url'].blank? && !product_attr['id'].blank?
      if _product = Product.find(product_attr['id'])
        self.product = _product
        return true
      else
        return false
      end
    end

    # One field blank means user hasn't filled out form properly (user error)
    if product_attr['name'].blank? || product_attr['thumbnail_url'].blank?
      return true
    end

    return false
  end

  # def check_if_product_exists(product_attr)
  #   if _product = Product.find(product_attr['id'])
  #     self.product = _product
  #     return true
  #   end
  #   return false
  # end

end
