class AddReferencesToPlans < ActiveRecord::Migration[6.0]
  def change
    add_reference :plans, :product, null: false, foreign_key: true
  end
end
