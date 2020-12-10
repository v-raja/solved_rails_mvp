# == Schema Information
#
# Table name: occupations
#
#  id                     :integer          not null, primary key
#  title                  :string
#  description            :text
#  code                   :integer          not null
#  slug                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  occupation_category_id :integer          not null
#
require 'test_helper'

class OccupationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
