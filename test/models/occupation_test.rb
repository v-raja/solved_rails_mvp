# == Schema Information
#
# Table name: occupations
#
#  id                     :bigint           not null, primary key
#  title                  :text
#  description            :text
#  code                   :text
#  slug                   :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  occupation_category_id :bigint           not null
#
require 'test_helper'

class OccupationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
