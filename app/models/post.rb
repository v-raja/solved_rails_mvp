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
#  gallery_id    :integer
#
class Post < ApplicationRecord
  has_many :industry_posts, dependent: :destroy
  has_many :industries, through: :industry_posts

  has_many :occupation_posts, dependent: :destroy
  has_many :occupations, through: :occupation_posts

  has_many :media_urls, dependent: :destroy
  belongs_to  :product

  scope :today,      -> { where('DATE(posts.created_at) = ?', Date.today) }
  scope :past_week,  -> { where("posts.created_at >= :start_date AND posts.created_at < :end_date", {:start_date => 1.week.ago, :end_date => Date.today }) }
  scope :past_month, -> { where("posts.created_at >= :start_date AND posts.created_at < :end_date", {:start_date => 1.month.ago, :end_date => 1.week.ago }) }

  def post_to_industry(industry)
    industries << industry
  end

  def post_to_occupation(occupation)
    occupations << occupation
  end
end
