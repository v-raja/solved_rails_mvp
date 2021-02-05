# == Schema Information
#
# Table name: suggested_communities
#
#  id             :bigint           not null, primary key
#  user_id        :integer
#  community      :text
#  community_type :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class SuggestedCommunity < ApplicationRecord
  belongs_to :user, optional: true
  validates_presence_of :community

end
