class CreateNiches < ActiveRecord::Migration[6.0]
  def change
    create_table :niches do |t|
      t.string :title
      t.text :description
      t.integer :code
      t.string :slug

      t.timestamps
    end
  end
end
