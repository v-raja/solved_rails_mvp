class GroupSolution < ApplicationRecord
  counter_culture :group, column_name: "solutions_count"
  counter_culture :group, column_name: "solution_votes_count", delta_column: "solution_votes"
  belongs_to :group, touch: true
  belongs_to :solution, touch: true
  validates_uniqueness_of :solution_id, :scope => :group_id
end
