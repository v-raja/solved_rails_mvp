class AddCommentsCountToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :comments_count, :integer, null: false, default: 0
  end
end
