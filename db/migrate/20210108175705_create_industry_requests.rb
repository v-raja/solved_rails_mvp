class CreateIndustryRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :industry_requests do |t|
      t.integer :request_id
      t.integer :industry_id
      t.timestamps
    end
    add_index :industry_requests, :request_id
    add_index :industry_requests, :industry_id
    add_index :industry_requests, [:request_id, :industry_id], unique: true
  end
end



