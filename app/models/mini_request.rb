class MiniRequest < ApplicationRecord
  belongs_to :user, optional: true
  validates_presence_of :description
  validate :email_or_user


  private

  def email_or_user
    if self.user.nil? && self.email.blank?
      errors.add(:email, :presence, message: "is required")
    end
  end
end
