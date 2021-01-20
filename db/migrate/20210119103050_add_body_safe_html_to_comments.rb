class AddBodySafeHtmlToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :body_safe_html, :text
  end
end
