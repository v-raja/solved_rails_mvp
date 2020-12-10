# == Schema Information
#
# Table name: occupation_posts
#
#  id            :integer          not null, primary key
#  post_id       :integer
#  occupation_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class OccupationPost < ApplicationRecord
  belongs_to :occupation
  belongs_to :post
  validates  :post_id, presence: true
  validates  :occupation_id, presence: true
  validates_uniqueness_of :post_id, :scope => :occupation_id
end
