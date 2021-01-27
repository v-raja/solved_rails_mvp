# == Schema Information
#
# Table name: requests
#
#  id                      :bigint           not null, primary key
#  title                   :text
#  description             :text
#  description_safe_html   :text
#  user_id                 :bigint           not null
#  slug                    :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#
require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
