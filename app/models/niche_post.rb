# == Schema Information
#
# Table name: niche_posts
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  niche_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class NichePost < ApplicationRecord
  belongs_to :niche
  belongs_to :post
  validates  :post_id, presence: true
  validates  :niche_id, presence: true
  validates_uniqueness_of :post_id, :scope => :niche_id
end
