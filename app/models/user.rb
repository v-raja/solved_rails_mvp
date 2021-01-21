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
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :validatable, :confirmable, :trackable

  validates_presence_of :name

  before_validation :add_thumbnail

  has_many :solutions
  has_many :requests
  # , dependent: :destroy

  acts_as_voter
  acts_as_follower

  def niche_list
    following_industries + following_occupations
  end

  def niche_list=(codes)
    self.follows_by_type('Industry').find_each(&:destroy)
    self.follows_by_type('Occupation').find_each(&:destroy)
    codes.reject!(&:blank?).map do |code|
      if industry = Industry.where(code: code).first
        self.follow(industry)
      elsif occupation = Occupation.where(code: code).first
        self.follow(occupation)
      end
    end
  end

  private

  def add_thumbnail
    if !name.blank? && thumbnail_url.blank?
      self.thumbnail_url = "https://avatar.oxro.io/avatar.svg?name=#{name[0]}&background=#{random_thumbnail_bg_color}&length=1"
    end
  end

  def random_thumbnail_bg_color
    colors = ["E284B3", "FFED8B",  "681313", "F3C1C6",  "735372",  "009975", "FFBD39", "B1E8ED", "52437B", "F76262", "216583", "293462", "DD9D52", "936B93", "6DD38D", "888888", "6F8190", "BCA0F0", "AAF4DD", "96C2ED", "3593CE", "5EE2CD", "96366E", "E38080"]
    colors.sample
  end
end
