class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.text :title
      t.text :description
      t.text :slug
      t.text :keywords
      t.integer :solutions_count, null: false, default: 0
      t.integer :solution_votes_count, null: false, default: 0
      t.timestamps
    end
    add_index :groups, :slug, unique: true
    add_index :groups, :title, unique: true
  end
end
