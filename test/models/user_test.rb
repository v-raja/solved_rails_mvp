# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :text             default(""), not null
#  encrypted_password     :text             default(""), not null
#  reset_password_token   :text
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :text
#  last_sign_in_ip        :text
#  confirmation_token     :text
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :text
#  name                   :text
#  bio                    :text
#  admin                  :boolean          default(FALSE)
#  thumbnail_url          :text
#  slug                   :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invitation_token       :text
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint
#  invitations_count      :integer          default(0)
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
