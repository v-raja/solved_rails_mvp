# == Schema Information
#
# Table name: industry_solutions
#
#  id             :bigint           not null, primary key
#  solution_id    :integer
#  industry_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  solution_votes :integer          default(0), not null
#
class IndustrySolution < ApplicationRecord
  belongs_to :industry, touch: true
  counter_culture :industry, column_name: "solutions_count"
  counter_culture :industry, column_name: "solution_votes_count", delta_column: "solution_votes"
  belongs_to :solution, touch: true

  validates_uniqueness_of :solution_id, :scope => :industry_id

end
