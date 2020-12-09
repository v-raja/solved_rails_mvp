class AddTypeToNiches < ActiveRecord::Migration[6.0]
  def change
    add_column :niches, :type, :string
  end
end
