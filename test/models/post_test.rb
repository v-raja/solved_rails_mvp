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
#
require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
