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
#  is_unlocked            :boolean          default(FALSE)
#
class Occupation < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  acts_as_followable
  has_many :suggested_keywords, :as => :community

  validates_presence_of :title, :description, :code

  belongs_to :category, class_name: "OccupationCategory", foreign_key: "occupation_category_id"

  # before_save :titleize_title

  has_many :occupation_solutions, dependent: :destroy
  has_many :solutions, through: :occupation_solutions

  has_many :occupation_requests, dependent: :destroy
  has_many :requests, through: :occupation_requests

  # default_scope { where(is_unlocked: true) }

  scope :popular,  -> { order(Arel.sql('solutions_count + solution_votes_count DESC')) }
  scope :is_postable, -> { where(is_postable: true) }

  include AlgoliaSearch

  algoliasearch index_name: 'niches', id: :code, raise_on_failure: Rails.env.development?, sanitize: true, per_environment: true do
    attribute :title, :description, :is_postable
    add_attribute :url, :type, :keyword_list

    searchableAttributes [ 'unordered(title)', 'unordered(keyword_list)', 'unordered(description)']
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
    # self.save
  end

  def all_keywords
    "#{self.keywords}; #{self.user_suggested_keywords}"
  end

  def check_and_set_is_postable_and_get_nb_followers
    nb_followers = self.nb_followers
    self.update(is_postable: self.solutions.exists? || self.is_unlocked || nb_followers >= 40)
    return {is_postable: self.is_postable, nb_followers: nb_followers}
  end

  # def titleize_title
  #   words_no_cap = ["and", "or", "the", "over", "to", "the", "a", "but", "of", "n.e.c.", "n.e.c", "as"]
  #   words_all_cap = ["It", "Hr", "r&d", "(r&d)"]
  #   phrase = title.titleize.split(" ").map {|word|
  #       if words_no_cap.include?(word.downcase)
  #           word.downcase
  #       elsif words_all_cap.include?(word)
  #           word.upcase
  #       else
  #           word
  #       end
  #   }.join(" ")
  #   self.title = phrase
  # end

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


  # def check_and_set_is_postable
  #   self.update(is_postable: self.is_unlocked || (self.nb_followers >= 40))
  #   self.is_postable
  # end


  def nb_followers
    # should compare times of both statements at some point
    Occupation.where("occupations.id = #{self.id}").joins("JOIN follows ON followable_id = occupations.id AND followable_type = '#{self.class.to_s}'").joins("JOIN users ON users.id = follower_id").where("users.confirmed_at IS NOT NULL").count
    # self.followers.delete_if(&:unconfirmed?).count
  end

  private

  def code_with_suffix
    "o/#{code}"
  end

  def url
    Rails.application.routes.url_helpers.occupation_path(self.slug)
  end

  def url_changed?
    slug_changed?
  end

  def keyword_list_changed?
    keywords_changed? || user_suggested_keywords_changed?
  end

  def type
    "Occupation"
  end
end
