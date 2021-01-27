# == Schema Information
#
# Table name: requests
#
#  id                      :bigint           not null, primary key
#  title                   :text
#  description             :text
#  description_safe_html   :text
#  user_id                 :bigint           not null
#  slug                    :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#
class Request < ApplicationRecord

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  class << self
    def markdown
      Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(no_images: true, no_styles: true, safe_links_only: true, hard_wrap: true, filter_html: true), auto_link: true, no_intra_emphasis: true, strikethrough: true)
    end
  end

  before_save :assign_description_safe_html , if: -> { description_changed? || description_safe_html.nil? }
  before_save :anti_spam, if: -> { description_safe_html_changed? }

  belongs_to :user
  validates_presence_of :title, :description

  validate :atleast_one_niche

  acts_as_followable
  acts_as_commentable
  acts_as_votable

  default_scope { order(created_at: :desc) }

  scope :today,      -> { where('requests.created_at >= ?', 1.day.ago) }
  scope :past_week,  -> { where("requests.created_at >= :start_date AND requests.created_at < :end_date", {:start_date => 1.week.ago, :end_date => 1.day.ago }) }
  scope :past_month, -> { where("requests.created_at >= :start_date AND requests.created_at < :end_date", {:start_date => 1.month.ago, :end_date => 1.week.ago }) }

  scope :top,        -> { unscoped.order(cached_votes_score: :desc).order(created_at: :desc) }

  has_many :industry_requests, dependent: :destroy
  has_many :industries, through: :industry_requests

  has_many :occupation_requests, dependent: :destroy
  has_many :occupations, through: :occupation_requests

  after_create :remake_slug

  def post_to_industry(industry)
    industries << industry
  end

  def post_to_occupation(occupation)
    occupations << occupation
  end

  def niche_list
    self.industries + self.occupations
  end

  def normalize_friendly_id(string)
    super[0..49]
  end

  def niche_list=(codes)
    industries = []
    occupations = []
    codes.reject!(&:blank?).map do |code|
      if industry = Industry.where(code: code).first
        industries << industry
      elsif occupation = Occupation.where(code: code).first
        occupations << occupation
      end
    end
    self.industries = industries
    self.occupations = occupations
  end

  private

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def remake_slug
    base_slug = normalize_friendly_id(self.title)
    if self.slug != base_slug
      new_slug = "#{base_slug}-#{self.id}"
      # if FriendlyId::Slug.where(sluggable_type: self.class.to_s).where('lower(slug) = ?', new_slug).exists?
      #   self.slug = nil
      # else
      self.slug = new_slug
      self.save
    end
  end

  def atleast_one_niche
    if industries.empty? && occupations.empty?
      errors.add(:communities, "can't be empty")
    end
  end

  def should_generate_new_friendly_id?
    self.slug.blank? || title_changed? || super
  end

  def assign_description_safe_html
    assign_attributes({
      description_safe_html: self.class.markdown.render(description.gsub(/\n/, '&nbsp;'))
    })
  end

  def anti_spam
    doc = Nokogiri::HTML::DocumentFragment.parse(self.description_safe_html)
    doc.css('a').each do |a|
      a[:rel] = 'nofollow ugc noopener'
      a[:target] = '_blank'
      a[:class] = 'user-link'
    end
    self.description_safe_html = doc.to_s
  end

end
