# == Schema Information
#
# Table name: industry_solutions
#
#  id          :bigint           not null, primary key
#  solution_id :integer
#  industry_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class IndustrySolution < ApplicationRecord
  belongs_to :industry, touch: true
  # counter_culture :industry, column_name: "solutions_count"
  belongs_to :solution, touch: true

  validates_uniqueness_of :solution_id, :scope => :industry_id

end
