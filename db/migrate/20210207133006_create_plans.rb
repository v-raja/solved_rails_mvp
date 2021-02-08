class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.text :name
      t.boolean :is_price_per_user, default: false
      t.decimal :price_per_month, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
