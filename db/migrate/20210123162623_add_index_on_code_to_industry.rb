class AddIndexOnCodeToIndustry < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    remove_index :industries, :code
    add_index :industries, :code, unique: true, algorithm: :concurrently
    add_index :keywords, [:code, :keyword], unique: true, algorithm: :concurrently
  end
end
