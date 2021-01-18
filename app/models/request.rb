# == Schema Information
#
# Table name: requests
#
#  id                      :bigint           not null, primary key
#  title                   :text
#  description             :text
#  user_id                 :bigint           not null
#  slug                    :text             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#
class Request < ApplicationRecord

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :user
  validates_presence_of :title, :description

  validate :atleast_one_niche

  acts_as_commentable
  acts_as_votable cacheable_strategy: :update_columns

  # default_scope { order(created_at: :desc) }

  scope :today,      -> { where('DATE(requests.created_at) = ?', Date.today) }
  scope :past_week,  -> { where("requests.created_at >= :start_date AND requests.created_at < :end_date", {:start_date => 1.week.ago, :end_date => Date.today }) }
  scope :past_month, -> { where("requests.created_at >= :start_date AND requests.created_at < :end_date", {:start_date => 1.month.ago, :end_date => 1.week.ago }) }

  scope :today_ordered_by_votes, -> { where('DATE(requests.created_at) = ?', Date.today).order(cached_votes_score: :desc) }
  scope :past_week_ordered_by_votes,  -> { where("requests.created_at >= :start_date AND requests.created_at < :end_date", {:start_date => 1.week.ago, :end_date => Date.today }).order(cached_votes_score: :desc) }
  scope :past_month_ordered_by_votes, -> { where("requests.created_at >= :start_date AND requests.created_at < :end_date", {:start_date => 1.month.ago, :end_date => 1.week.ago }).order(cached_votes_score: :desc) }

  has_many :industry_requests, dependent: :destroy
  has_many :industries, through: :industry_requests

  has_many :occupation_requests, dependent: :destroy
  has_many :occupations, through: :occupation_requests

  def post_to_industry(industry)
    industries << industry
  end

  def post_to_occupation(occupation)
    occupations << occupation
  end

  private

  def atleast_one_niche
    if industries.empty? && occupations.empty?
      errors.add(:niches, "can't be empty")
    end
  end

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

end
