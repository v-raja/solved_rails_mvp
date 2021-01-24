# == Schema Information
#
# Table name: keywords
#
#  id         :bigint           not null, primary key
#  code       :text
#  keyword    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class KeywordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
