class CreateGroupSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :group_solutions do |t|
      t.references :group, null: false, foreign_key: true
      t.references :solution, null: false, foreign_key: true
      t.integer :solution_votes, null: false, default: 0
      t.timestamps
    end
    add_index :group_solutions, [:solution_id, :group_id], unique: true
  end
end
