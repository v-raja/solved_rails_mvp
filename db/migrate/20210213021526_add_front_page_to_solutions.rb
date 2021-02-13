class AddFrontPageToSolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :solutions, :front_page, :boolean, default: true
  end
end
