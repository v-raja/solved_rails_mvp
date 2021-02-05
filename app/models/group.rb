class Group < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates_presence_of :title

  has_many :group_solutions, dependent: :destroy
  has_many :solutions, through: :group_solutions

  has_many :suggested_keywords

  scope :popular,  -> { order(Arel.sql('solutions_count + solution_votes_count DESC')) }

  acts_as_followable

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def tags
    (self.solutions.tag_counts_on(:niche_specific_tags) + self.solutions.tag_counts_on(:general_tags)).uniq
  end

  def nb_followers
    Group.where("groups.id = #{self.id}").joins("JOIN follows ON followable_id = groups.id AND followable_type = '#{self.class.to_s}'").joins("JOIN users ON users.id = follower_id").where("users.confirmed_at IS NOT NULL").count
  end

  def keyword_list
    if self.keywords
      self.keywords.split("; ")
    else
      []
    end
  end

  def add_user_suggested_keyword(keyword)
    if self.keywords.blank?
      self.update(keywords: keyword)
    else
      self.update(keywords: "#{keywords}; #{keyword}")
    end
  end

  private

  def type
    "Group"
  end
end
