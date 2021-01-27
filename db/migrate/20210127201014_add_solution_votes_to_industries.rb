class AddSolutionVotesToIndustries < ActiveRecord::Migration[6.0]
  def change
    add_column :industries, :solution_votes, :integer, null: false, default: 0
  end
end
