class AddIsHappyUserToFeedbacks < ActiveRecord::Migration[6.0]
  def change
    add_column :feedbacks, :is_happy_user, :boolean, default: false
  end
end
