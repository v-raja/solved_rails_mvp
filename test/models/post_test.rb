# == Schema Information
#
# Table name: solutions
#
#  id            :integer          not null, primary key
#  title :string
#  tagline       :string
#  description   :text
#  get_it_url   :string
#  product_id    :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
