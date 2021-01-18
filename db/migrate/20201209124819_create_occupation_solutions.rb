class CreateOccupationSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :occupation_solutions do |t|
      t.integer :solution_id
      t.integer :occupation_id
      t.timestamps
    end
    add_index :occupation_solutions, :solution_id
    add_index :occupation_solutions, :occupation_id
    add_index :occupation_solutions, [:solution_id, :occupation_id], unique: true
  end
end
