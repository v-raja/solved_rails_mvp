class AddIsCreatorToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :is_creator, :boolean, default: false
  end
end
