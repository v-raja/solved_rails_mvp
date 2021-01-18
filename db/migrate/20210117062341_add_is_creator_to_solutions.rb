class AddIsCreatorToSolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :solutions, :is_creator, :boolean, default: false
  end
end
