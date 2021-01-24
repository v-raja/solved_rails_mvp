class CreateKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :keywords do |t|
      t.text :code
      t.text :keyword

      t.timestamps
    end
    add_index :keywords, :code
    change_column_null :keywords, :code, false
    change_column_null :keywords, :keyword, false
  end
end
