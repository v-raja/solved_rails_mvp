class AddDescriptionSafeHtmlToSolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :solutions, :description_safe_html, :text
  end
end
