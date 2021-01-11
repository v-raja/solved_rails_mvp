class CreateOccupationRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :occupation_requests do |t|
      t.integer :request_id
      t.integer :occupation_id
      t.timestamps
    end
    add_index :occupation_requests, :request_id
    add_index :occupation_requests, :occupation_id
    add_index :occupation_requests, [:request_id, :occupation_id], unique: true
  end
end
