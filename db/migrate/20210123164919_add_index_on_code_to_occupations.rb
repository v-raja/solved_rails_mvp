class AddIndexOnCodeToOccupations < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    remove_index :occupations, :code
    add_index :occupations, :code, unique: true, algorithm: :concurrently
  end
end
