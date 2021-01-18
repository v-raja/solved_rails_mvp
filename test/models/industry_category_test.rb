# == Schema Information
#
# Table name: industry_categories
#
#  id             :bigint           not null, primary key
#  title          :text
#  description    :text
#  code           :text
#  slug           :text
#  type           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#
require 'test_helper'

class IndustryCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
