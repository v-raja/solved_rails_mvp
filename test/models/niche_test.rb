# == Schema Information
#
# Table name: niches
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  code        :integer          not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  type        :string
#
require 'test_helper'

class NicheTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
