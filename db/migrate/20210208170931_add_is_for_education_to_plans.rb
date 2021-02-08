class AddIsForEducationToPlans < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :is_for_education, :boolean, default: false
  end
end
