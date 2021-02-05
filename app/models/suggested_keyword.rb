# == Schema Information
#
# Table name: suggested_keywords
#
#  id              :bigint           not null, primary key
#  industry_slug   :text
#  occupation_slug :text
#  keyword         :text
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class SuggestedKeyword < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :industry, foreign_key: "industry_slug", primary_key: "slug", optional: true
  belongs_to :occupation, foreign_key: "occupation_slug", primary_key: "slug", optional: true
  belongs_to :group, foreign_key: "group_slug", primary_key: "slug", optional: true
  validates_presence_of :keyword

  # validate :only_one_community

  private

  # def only_one_community
  #   if self.industry.nil? && self.occupation.nil?
  #     errors.add(:community, "must be an industry or occupation")
  #   end
  #   if self.industry.present? && self.occupation.present?
  #     errors.add(:community, "can only be one of industry or occupation")
  #   end
  # end

end
