# == Schema Information
#
# Table name: plans
#
#  id                :bigint           not null, primary key
#  name              :text
#  is_price_per_user :boolean          default(FALSE)
#  price_per_month   :decimal(8, 2)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  product_id        :bigint           not null
#
class Plan < ApplicationRecord
  validates_presence_of :name, :price_per_month
  belongs_to :product, touch: true # Not actually optional. We save it without a product and then add a product once it is created.
  has_many :solutions
  after_save { solutions.each(&:touch) }
  validates :price_per_month, :numericality => { :greater_than_or_equal_to => 0 }
end
