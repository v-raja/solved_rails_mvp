class SuggestedCommunity < ApplicationRecord
  belongs_to :user, optional: true
  validates_presence_of :community

end
