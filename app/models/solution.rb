# == Schema Information
#
# Table name: solutions
#
#  id                      :bigint           not null, primary key
#  title                   :text
#  description             :text
#  get_it_url              :text
#  product_id              :bigint           not null
#  slug                    :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :bigint           not null
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  is_creator              :boolean          default(FALSE)
#
class Solution < ApplicationRecord

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  validates_presence_of :title, :description, :youtube_urls, :product
  validate :atleast_one_niche

  has_many :industry_solutions, dependent: :destroy
  has_many :industries, through: :industry_solutions

  has_many :occupation_solutions, dependent: :destroy
  has_many :occupations, through: :occupation_solutions

  has_many :youtube_urls, dependent: :destroy
  accepts_nested_attributes_for :youtube_urls, allow_destroy: true, reject_if: proc { |att| att['url'].blank? }

  belongs_to :product
  accepts_nested_attributes_for :product, :reject_if => :check_if_product_exists

  # validates_presence_of :product_id, :unless => "product.present?"
  validates_associated :product
  validates :get_it_url, url: { no_local: true }

  belongs_to :user

  # default_scope { order(created_at: :desc) }

  acts_as_commentable
  acts_as_votable cacheable_strategy: :update_columns
  acts_as_taggable

  default_scope { order(created_at: :desc) }

  scope :today,      -> { where('solutions.created_at >= ?', 1.day.ago) }
  scope :past_week,  -> { where("solutions.created_at >= :start_date AND solutions.created_at < :end_date", {:start_date => 1.week.ago, :end_date => 1.day.ago }) }
  scope :past_month, -> { where("solutions.created_at >= :start_date AND solutions.created_at < :end_date", {:start_date => 1.month.ago, :end_date => 1.week.ago }) }

  scope :top,        -> { unscoped.order(cached_votes_score: :desc).order(created_at: :desc) }

  scope :today_ordered_by_votes, -> { where('DATE(solutions.created_at) = ?', Date.today).order(cached_votes_score: :desc) }
  scope :past_week_ordered_by_votes,  -> { where("solutions.created_at >= :start_date AND solutions.created_at < :end_date", {:start_date => 1.week.ago, :end_date => Date.today }).order(cached_votes_score: :desc) }
  scope :past_month_ordered_by_votes, -> { where("solutions.created_at >= :start_date AND solutions.created_at < :end_date", {:start_date => 1.month.ago, :end_date => 1.week.ago }).order(cached_votes_score: :desc) }

  include AlgoliaSearch

  algoliasearch index_name: 'solutions', sanitize: true, per_environment: true, raise_on_failure: Rails.env.development? do
    attribute :created_at, :title, :description

    # integer version of the created_at datetime field, to use numerical filtering
    attribute :created_at_i do
      created_at.to_i
    end

    attribute :user do
      { name: user.name }
    end

    attribute :product do
      { name: product.name, thumbnail_url: product.thumbnail_url, url: Rails.application.routes.url_helpers.product_path(product) }
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

    searchableAttributes ['unordered(title)', 'unordered(description)']

    # industries.each do |i|
    #   add_index i.code_with_suffix do
    #     attribute :created_at, :title, :description, :url

    #     # integer version of the created_at datetime field, to use numerical filtering
    #     attribute :created_at_i do
    #       created_at.to_i
    #     end

    #     attribute :user do
    #       { name: user.name }
    #     end

    #     attribute :product do
    #       { name: product.name, thumbnail_url: product.thumbnail_url, url: Rails.application.routes.url_helpers.product_path(product) }
    #     end


    #     searchableAttributes ['unordered(title)', 'unordered(description)']
    #   end
    # end
  end

  def post_to_industry(industry)
    industries << industry
  end

  def post_to_occupation(occupation)
    occupations << occupation
  end

  private

  def url
    Rails.application.routes.url_helpers.solution_path(id)
  end

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

  def atleast_one_niche
    if industries.empty? && occupations.empty?
      errors.add(:niches, "can't be empty")
    end
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  # def check_if_product_exists(product_attr)
  #   if _product = Product.find(product_attr['id'])
  #     self.product = _product
  #     return true
  #   end
  #   return false
  # end

end
