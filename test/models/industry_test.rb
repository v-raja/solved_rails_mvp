# == Schema Information
#
# Table name: industries
#
#  id                   :bigint           not null, primary key
#  title                :text
#  description          :text
#  code                 :text
#  slug                 :text
#  keywords             :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  industry_category_id :bigint           not null
#  solutions_count      :integer          default(0), not null
#  requests_count       :integer          default(0), not null
#  solution_votes_count :integer          default(0), not null
#  is_unlocked          :boolean          default(FALSE)
#
require 'test_helper'

class IndustryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
