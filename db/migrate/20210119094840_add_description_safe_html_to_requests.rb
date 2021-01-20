class AddDescriptionSafeHtmlToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :description_safe_html, :text
  end
end
