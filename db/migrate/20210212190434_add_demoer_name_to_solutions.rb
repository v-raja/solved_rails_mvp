class AddDemoerNameToSolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :solutions, :demoer_name, :text
  end
end
