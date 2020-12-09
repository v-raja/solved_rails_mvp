class Occupation < Niche
  validates :code,        presence: true,
                          numericality: { only_integer: true,
                                          greater_than_or_equal_to: 1000,
                                          less_than_or_equal_to:    9999 }

end
