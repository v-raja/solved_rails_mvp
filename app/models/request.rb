# == Schema Information
#
# Table name: requests
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Request < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :description

  acts_as_commentable
  acts_as_votable

  scope :today,      -> { where('DATE(requests.created_at) = ?', Date.today) }
  scope :past_week,  -> { where("requests.created_at >= :start_date AND requests.created_at < :end_date", {:start_date => 1.week.ago, :end_date => Date.today }) }
  scope :past_month, -> { where("requests.created_at >= :start_date AND requests.created_at < :end_date", {:start_date => 1.month.ago, :end_date => 1.week.ago }) }

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

end
