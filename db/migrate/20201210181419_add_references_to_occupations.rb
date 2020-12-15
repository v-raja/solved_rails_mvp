class AddReferencesToOccupations < ActiveRecord::Migration[6.0]
  def change
    add_reference :occupations, :occupation_category, null: false, foreign_key: true
  end
end
