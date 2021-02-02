class AddIsPostableToOccupations < ActiveRecord::Migration[6.0]
  def change
    add_column :occupations, :is_postable, :boolean, default: false
  end
end
