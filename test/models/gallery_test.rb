# == Schema Information
#
# Table name: galleries
#
#  id            :integer          not null, primary key
#  thumbnail_url :string
#  solution_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'test_helper'

class GalleryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
