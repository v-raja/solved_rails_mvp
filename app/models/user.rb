# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  pseudonym              :string
#  role                   :string
#  company                :string
#  fake_company           :string
#  admin                  :boolean          default(FALSE)
#  thumbnail_url          :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates_presence_of :name

  before_validation :add_thumbnail

  has_many :posts
  has_many :requests
  # , dependent: :destroy

  acts_as_voter


  private

  def add_thumbnail
    if !name.blank? && thumbnail_url.blank?
      self.thumbnail_url = "https://avatar.oxro.io/avatar.svg?name=#{name[0]}&background=#{random_thumbnail_bg_color}&length=1"
    end
  end

  def random_thumbnail_bg_color
    colors = ["#E284B3", "#FFED8B",  "#681313", "#F3C1C6",  "#735372",  "#009975", "#FFBD39", "#B1E8ED", "#52437B", "#F76262", "#216583", "#293462", "#DD9D52", "#936B93", "#6DD38D", "#888888", "#6F8190", "#BCA0F0", "#AAF4DD", "#96C2ED", "#3593CE", "#5EE2CD", "#96366E", "#E38080"]
    colors.sample
  end
end
