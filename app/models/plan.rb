class Plan < ApplicationRecord
  validates_presence_of :name, :price_per_month
  belongs_to :product # Not actually optional. We save it without a product and then add a product once it is created.
  has_many :solutions
  validates :price_per_month, :numericality => { :greater_than_or_equal_to => 0 }
end
