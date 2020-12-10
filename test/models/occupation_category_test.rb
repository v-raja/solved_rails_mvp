# == Schema Information
#
# Table name: occupation_categories
#
#  id         :integer          not null, primary key
#  title      :string
#  code       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string
#
require 'test_helper'

class OccupationCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
