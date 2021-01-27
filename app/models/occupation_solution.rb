# == Schema Information
#
# Table name: occupation_solutions
#
#  id             :bigint           not null, primary key
#  solution_id    :integer
#  occupation_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  solution_votes :integer          default(0), not null
#
class OccupationSolution < ApplicationRecord
  belongs_to :occupation, touch: true
  counter_culture :occupation, column_name: "solutions_count"
  counter_culture :occupation, column_name: "solution_votes_count", delta_column: "solution_votes"
  belongs_to :solution, touch: true
  # validates  :solution_id, presence: true
  # validates  :occupation_id, presence: true
  validates_uniqueness_of :solution_id, :scope => :occupation_id
end
