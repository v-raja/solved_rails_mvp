class AddSolutionVotesCountToOccupations < ActiveRecord::Migration[6.0]
  def change
    add_column :occupations, :solution_votes_count, :integer, null: false, default: 0
  end
end
