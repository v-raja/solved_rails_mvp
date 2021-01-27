class AddSolutionVotesToIndustrySolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :industry_solutions, :solution_votes, :integer, null: false, default: 0
  end
end
