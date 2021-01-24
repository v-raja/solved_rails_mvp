class MakeSlugNullableForSolutions < ActiveRecord::Migration[6.0]
  def change
    change_column :solutions, :slug, :text, :null => true
  end
end
