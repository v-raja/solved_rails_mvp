# == Schema Information
#
# Table name: industries
#
#  id                   :integer          not null, primary key
#  title                :string
#  description          :text
#  slug                 :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  industry_category_id :integer          not null
#
require 'test_helper'

class IndustryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
