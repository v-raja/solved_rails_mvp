class MakeSlugNullableForRequests < ActiveRecord::Migration[6.0]
  def change
    change_column :requests, :slug, :text, :null => true
  end
end
