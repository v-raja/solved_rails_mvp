class Niche < ApplicationRecord

  validates :title,       presence: true
  validates :description, presence:true
  validates :slug,        presence: true,
                          uniqueness: { case_sensitive: false }
  validates :code,        presence: true,
                          numericality: { only_integer: true,
                                          greater_than_or_equal_to: 100000,
                                          less_than_or_equal_to:    999999 }
end
