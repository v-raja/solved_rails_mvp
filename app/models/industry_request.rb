# == Schema Information
#
# Table name: industry_requests
#
#  id          :bigint           not null, primary key
#  request_id  :integer
#  industry_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class IndustryRequest < ApplicationRecord
  belongs_to :industry
  belongs_to :request
  # validates  :request_id, presence: true
  # validates  :industry_id, presence: true
  validates_uniqueness_of :request_id, :scope => :industry_id
end
