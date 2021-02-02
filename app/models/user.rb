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
require 'addressable/uri'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :validatable, :confirmable, :trackable

  has_many :login_activities, as: :user

  validates_presence_of :name
  before_validation :add_thumbnail, except: :create

  before_validation :set_default_name_and_thumbnail, on: :create
  validates :thumbnail_url, url: { no_local: true }

  # Problem: need to assign names and thumbnails when user signs up from a community page.
  # So we used a before_create callback. This works as expected.
  # But we validate thumbnail url in general. So if user signs up from sign up page,
  # the thumbnail validation fails as the default url is set only after the validation.
  # Thus, we call set_default_name_and_thumbnail two times for each case of signing up.
  before_create :set_default_name_and_thumbnail

  # Want to init name and thumbnail, even if validation is skipped

  # For invitations and confirmations
  # attr_accessor :confirmation_instructions
  attr_accessor :invitation_instructions
  attr_accessor :niche


  has_many :solutions
  has_many :requests
  # , dependent: :destroy

  acts_as_voter
  acts_as_follower

  def niche_list
    following_industries + following_occupation
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

  # Use when you only want to confirm the email without setting password
  # def self.invite_subscriber!(attributes={}, niche=nil)
  #   u = nil
  #   if u = User.find_by(email: attributes[:attributes][:email])
  #     if !u.confirmed?
  #       u.niche = niche
  #       u.confirmation_instructions = :subscriber_confirmation_instructions
  #       u.send_confirmation_instructions
  #     end
  #   else
  #     u = self.invite!(attributes) do |u|
  #       u.skip_invitation = true
  #     end
  #     u.niche = niche
  #     u.confirmation_instructions = :subscriber_confirmation_instructions
  #     u.send_confirmation_instructions
  #   end
  #   u
  # end

  def self.invite_subscriber!(attributes={}, niche=nil)
    u = self.invite!(attributes) do |invitable|
      invitable.invitation_instructions = :follower_invitation_instructions
      invitable.niche = niche
    end
    u
    # u = nil
    # if u = User.find_by(email: attributes[:attributes][:email])
    #   if !u.confirmed?
    #     u.niche = niche
    #     u.invitation_instructions = :follower_confirmation_instructions
    #     u.send_confirmation_instructions
    #   end
    # else
    #   u = self.invite!(attributes) do |u|
    #     u.skip_invitation = true
    #   end
    #   u.niche = niche
    #   u.invitation_instructions = :follower_confirmation_instructions
    #   u.send_confirmation_instructions
    # end
    # u
  end

  def unconfirmed?
    !self.confirmed?
  end
  # def self.invite_poster!(attributes={}, invited_by=nil)
  #   self.invite!(attributes, invited_by) do |invitable|
  #     invitable.invitation_instructions = :poster_invitation_instructions
  #   end
  # end

  protected

  def send_devise_notification(notification, *args)
    if Rails.env.production?
      devise_mailer.send(notification, self, *args).deliver_later
    else
      devise_mailer.send(notification, self, *args).deliver
    end
  end

  private

  def set_default_name_and_thumbnail
    # byebug
    self.name ||= "Your name here"
    self.thumbnail_url ||= "https://avatar.oxro.io/avatar.svg?name=#{self.name[0]}&background=#{random_thumbnail_bg_color}&length=1"
    # self.update(:name, "Your name here") unless self.name.present?
    # self.update(:thumbnail_url, "https://avatar.oxro.io/avatar.svg?name=#{self.name[0]}&background=#{random_thumbnail_bg_color}&length=1")
  end

  def add_thumbnail
    # if !self.new_record? && self.thumbnail_url.blank?
    #   if name_changed?
    #     self.thumbnail_url = "https://avatar.oxro.io/avatar.svg?name=#{self.name[0]}&background=#{random_thumbnail_bg_color}&length=1"
    #   else
    #     self.thumbnail_url = self.old_thumbnail_url
    #   end
    # end

    if !self.new_record? && (self.thumbnail_url.blank? || (name_changed? && is_oxro_url?(self.thumbnail_url)))
      self.thumbnail_url = "https://avatar.oxro.io/avatar.svg?name=#{self.name[0]}&background=#{random_thumbnail_bg_color}&length=1"
    end
    # If I edit profile, will thumbnail URL be set before this function?
    # if !self.name.blank? && self.thumbnail_url.blank?
    #   self.thumbnail_url = "https://avatar.oxro.io/avatar.svg?name=#{self.name[0]}&background=#{random_thumbnail_bg_color}&length=1"
    # end
    # if name_changed?
    #   if is_oxro_url?(self.thumbnail_url)
    #     self.thumbnail_url = "https://avatar.oxro.io/avatar.svg?name=#{self.name[0]}&background=#{random_thumbnail_bg_color}&length=1"
    #   end
    # end
  end

  def is_oxro_url?(url)
    Addressable::URI.parse(url).host == "avatar.oxro.io"
  end

  def random_thumbnail_bg_color
    colors = ["E284B3", "FFED8B",  "681313", "F3C1C6",  "735372",  "009975", "FFBD39", "B1E8ED", "52437B", "F76262", "216583", "293462", "DD9D52", "936B93", "6DD38D", "888888", "6F8190", "BCA0F0", "AAF4DD", "96C2ED", "3593CE", "5EE2CD", "96366E", "E38080"]
    colors.sample
  end
end
