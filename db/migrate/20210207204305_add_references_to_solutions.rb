class AddReferencesToSolutions < ActiveRecord::Migration[6.0]
  def change
    add_reference :solutions, :plan, foreign_key: true
  end
end
