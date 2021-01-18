class RemoveRoleAndCompanyFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :pseudonum, :string
    remove_column :users, :company, :string
    remove_column :users, :fake_company, :string
    remove_column :users, :role, :string
  end
end
