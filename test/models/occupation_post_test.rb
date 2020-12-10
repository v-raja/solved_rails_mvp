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
require 'test_helper'

class OccupationPostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
