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
#  is_unlocked          :boolean          default(FALSE)
#

class Industry < ApplicationRecord

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  validates_presence_of :title, :description, :code

  has_many :industry_solutions, dependent: :destroy
  has_many :solutions, through: :industry_solutions

  has_many :industry_requests, dependent: :destroy
  has_many :requests, through: :industry_requests

  # default_scope { is_postable }

  scope :popular,  -> { order(Arel.sql('solutions_count + solution_votes_count DESC')) }
  # scope :is_postable, -> { where(is_unlocked: true). }
  # scope :is_postable, -> {  joins("JOIN follows ON followable_id = industries.id AND followable_type = 'Industry'").joins("JOIN users ON users.id = follower_id").where("users.confirmed_at IS NOT NULL").group('industries.id').having('COUNT(follows.*) >= 1').or(where('user.confirmed_at IS NOT NULL')) }
  scope :is_postable, -> { where(is_postable: true) }
  # def self.execute_sql(*sql_array)
  #   connection.execute(send(:sanitize_sql_array, sql_array))
  # end
  acts_as_followable

  has_many :suggested_keywords, :as => :community

  # before_save :titleize_title

  belongs_to :category, class_name: "IndustryCategory", foreign_key: "industry_category_id"

  include AlgoliaSearch

  algoliasearch index_name: 'niches', id: :code, sanitize: true, raise_on_failure: Rails.env.development?, per_environment: true do
    attribute :title, :description, :is_postable
    add_attribute :url, :type, :keyword_list

    searchableAttributes [ 'unordered(title)', 'unordered(keyword_list)', 'unordered(description)']
  end

  # def titleize_title
  #   words_no_cap = ["and", "or", "the", "over", "to", "the", "a", "but", "of"]
  #   self.title = title.titleize(exclusions: words_no_cap)
  # end

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
    if self.all_keywords
      self.all_keywords.split("; ")
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

  def add_user_suggested_keyword(keyword)
    if self.user_suggested_keywords.blank?
      self.update(user_suggested_keywords: keyword)
    else
      self.update(user_suggested_keywords: "#{user_suggested_keywords}; #{keyword}")
    end
  end

  def all_keywords
    "#{self.keywords}; #{self.user_suggested_keywords}"
  end

  def check_and_set_is_postable_and_get_nb_followers
    nb_followers = self.nb_followers
    self.update(is_postable: self.is_unlocked || nb_followers >= 40)
    return {is_postable: self.is_postable, nb_followers: nb_followers}
  end

  # can't use ? at end because algolia can't take it :(
  # def check_and_set_is_postable
  #   self.update(is_postable: self.is_unlocked || (self.nb_followers >= 40))
  #   self.is_postable
  # end

  def nb_followers
    # should compare times of both statements at some point
    Industry.where("industries.id = #{self.id}").joins("JOIN follows ON followable_id = industries.id AND followable_type = '#{self.class.to_s}'").joins("JOIN users ON users.id = follower_id").where("users.confirmed_at IS NOT NULL").count
    # self.followers.delete_if(&:unconfirmed?).count
  end


  private

  def url
    Rails.application.routes.url_helpers.industry_path(self.slug)
  end

  def url_changed?
    slug_changed?
  end

  def keyword_list_changed?
    keywords_changed? || user_suggested_keywords_changed?
  end

  def code_with_suffix
    "i/#{code}"
  end

  def type
    "Industry"
  end

end
