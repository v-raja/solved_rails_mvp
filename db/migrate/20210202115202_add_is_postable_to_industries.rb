class AddIsPostableToIndustries < ActiveRecord::Migration[6.0]
  def change
    add_column :industries, :is_postable, :boolean, default: false
  end
end
