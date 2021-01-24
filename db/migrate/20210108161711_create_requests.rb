class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.text :title
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.text :slug

      t.timestamps
    end

    add_index :requests, :slug, unique: true
  end
end
