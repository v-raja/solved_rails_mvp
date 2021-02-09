class CreateFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.text :description
      t.text :email

      t.timestamps
    end
  end
end
