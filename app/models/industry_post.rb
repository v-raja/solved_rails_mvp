# == Schema Information
#
# Table name: industry_posts
#
#  id          :integer          not null, primary key
#  post_id     :integer
#  industry_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class IndustryPost < ApplicationRecord
  belongs_to :industry
  belongs_to :post
  validates  :post_id, presence: true
  validates  :industry_id, presence: true
  validates_uniqueness_of :post_id, :scope => :industry_id
end
