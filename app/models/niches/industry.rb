class Industry < Niche
  validates :code,        presence: true,
                          numericality: { only_integer: true,
                                          greater_than_or_equal_to: 100000,
                                          less_than_or_equal_to:    999999 }
  validates :description, presence: true

end
