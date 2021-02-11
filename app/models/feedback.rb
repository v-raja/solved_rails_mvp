class Feedback < ApplicationRecord
  validates_presence_of :description
  belongs_to :user, optional: true
end
