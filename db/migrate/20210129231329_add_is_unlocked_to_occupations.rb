class AddIsUnlockedToOccupations < ActiveRecord::Migration[6.0]
  def change
    add_column :occupations, :is_unlocked, :boolean, default: false
  end
end
