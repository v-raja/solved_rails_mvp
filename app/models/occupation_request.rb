# == Schema Information
#
# Table name: occupation_requests
#
#  id            :bigint           not null, primary key
#  request_id    :integer
#  occupation_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class OccupationRequest < ApplicationRecord
  belongs_to :occupation
  belongs_to :request
  # validates  :request_id, presence: true
  # validates  :occupation_id, presence: true
  validates_uniqueness_of :request_id, :scope => :occupation_id
end
