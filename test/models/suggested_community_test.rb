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
require 'test_helper'

class SuggestedCommunityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
