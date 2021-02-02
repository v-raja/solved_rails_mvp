class AddIsUnlockedToIndustries < ActiveRecord::Migration[6.0]
  def change
    add_column :industries, :is_unlocked, :boolean, default: false
  end
end
