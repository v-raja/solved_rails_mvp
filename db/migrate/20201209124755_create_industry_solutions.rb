class CreateIndustrySolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :industry_solutions do |t|
      t.integer :solution_id
      t.integer :industry_id
      t.timestamps
    end
    add_index :industry_solutions, :solution_id
    add_index :industry_solutions, :industry_id
    add_index :industry_solutions, [:solution_id, :industry_id], unique: true
  end
end
