# == Schema Information
#
# Table name: plans
#
#  id                :bigint           not null, primary key
#  name              :text
#  is_price_per_user :boolean          default(FALSE)
#  price_per_month   :decimal(8, 2)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  product_id        :bigint           not null
#
require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
