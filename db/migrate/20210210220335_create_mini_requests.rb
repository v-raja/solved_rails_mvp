class CreateMiniRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :mini_requests do |t|
      t.text :description
      t.text :email
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
