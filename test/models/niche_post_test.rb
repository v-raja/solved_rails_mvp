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
require 'test_helper'

class NichePostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
