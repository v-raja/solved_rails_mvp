# == Schema Information
#
# Table name: products
#
#  id            :bigint           not null, primary key
#  name          :text
#  thumbnail_url :text
#  slug          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
