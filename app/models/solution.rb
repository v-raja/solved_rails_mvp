# == Schema Information
#
# Table name: solutions
#
#  id                      :bigint           not null, primary key
#  title                   :text
#  description             :text
#  description_safe_html   :text
#  get_it_url              :text
#  product_id              :bigint           not null
#  slug                    :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :bigint           not null
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  is_creator              :boolean          default(FALSE)
#  comments_count          :integer          default(0), not null
#  plan_id                 :bigint
#
class Solution < ApplicationRecord

  class << self
    def markdown
      Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(no_images: true, no_styles: true, safe_links_only: true, hard_wrap: true), auto_link: true, no_intra_emphasis: true, strikethrough: true)
    end
  end

  acts_as_followable
  acts_as_votable

  before_save :assign_description_safe_html , if: -> { description_changed? || description_safe_html.nil? }
  before_save :anti_spam, if: -> { description_safe_html_changed? }

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  validates_presence_of :title, :youtube_urls, :product, :get_it_url
  validate :atleast_one_niche
  # validates_length_of :description

  has_many :industry_solutions, dependent: :destroy
  has_many :industries, through: :industry_solutions

  has_many :occupation_solutions, dependent: :destroy
  has_many :occupations, through: :occupation_solutions

  has_many :group_solutions, dependent: :destroy
  has_many :groups, through: :group_solutions

  has_many :youtube_urls, dependent: :destroy
  accepts_nested_attributes_for :youtube_urls, allow_destroy: true, reject_if: proc { |att| att['url'].blank? }

  belongs_to :product #, touch: true // not needed as we're not caching product
  accepts_nested_attributes_for :product, :reject_if => :check_if_product_exists

  validates_associated :product
  # validates :get_it_url, url: { no_local: true }

  belongs_to :user
  belongs_to :plan
  accepts_nested_attributes_for :plan, :reject_if => :check_if_plan_exists

  after_create :remake_slug

  acts_as_commentable
  accepts_nested_attributes_for :comment_threads, reject_if: proc { |att| att['body'].blank? }, limit: 1

  acts_as_taggable_on :general_tags, :niche_specific_tags, :platform

  # default_scope { most_recent }

  scope :today,           -> { where('solutions.created_at >= ?', 1.day.ago) }
  scope :past_week,       -> { where("solutions.created_at >= :start_date AND solutions.created_at < :end_date", {:start_date => 1.week.ago, :end_date => 1.day.ago }) }
  scope :past_month,      -> { where("solutions.created_at >= :start_date AND solutions.created_at < :end_date", {:start_date => 1.month.ago, :end_date => 1.week.ago }) }

  scope :top,             -> { order(cached_votes_score: :desc) }
  scope :most_recent,     -> { order(created_at: :desc) }

  scope :by_industries,   -> (industries) { joins(:industry_solutions).where("industry_solutions.industry_id IN (?)", industries) }
  scope :by_occupations,   -> (occupations) { joins(:occupation_solutions).where("occupation_solutions.occupation_id IN (?)", occupations) }
  scope :by_communities,  -> (communities) { joins(:industry_solutions).joins(:occupation_solutions).where("industry_solutions.industry_id IN (?) OR occupation_solutions.occupation_id IN (?)", communities, communities).distinct }

  scope :front_page, -> { where(front_page: true) }

  after_touch :index!

  include AlgoliaSearch

  algoliasearch index_name: 'solutions', per_environment: true, raise_on_failure: Rails.env.development?, if: :user_confirmed do
    attribute :created_at, :title, :is_creator, :comments_count, :description

    add_attribute :url

    attribute :nb_votes do
      cached_votes_score
    end

    attribute :description_text do
      description_safe_html
    end

    # integer version of the created_at datetime field, to use numerical filtering
    attribute :created_at_i do
      created_at.to_i
    end

    attribute :user do
      { name: user.name }
    end

    attribute :product do
      { name: product.name, thumbnail_url: product.thumbnail_url, url: Rails.application.routes.url_helpers.product_path(product),
        plan: plan_for_search }
    end

    attribute :communities do
      communities_for_search
    end

    attribute :videos do
      youtube_urls.map do |yt|
        { youtube_id: yt.youtube_id }
      end
    end

    # attribute :industries do
    #   industries.map do |i|
    #     { title: i.title, keywords: i.keyword_list, type: "Industry" }
    #   end
    # end

    # attribute :occupations do
    #   occupations.map do |o|
    #     { title: o.title, keywords: o.keyword_list, type: "Occupation" }
    #   end
    # end

    attribute :niche_specific_tags do
      niche_specific_tag_list
    end

    attribute :platforms do
      platform_list.map {|p| Solution.platform_name_stylized(p) }
    end

    tags do
      general_tag_list
    end

    # search for title, industry, occupation, description
    # rank by comments count, is is_creator
    # facet by tags, niche_specific tags, industries, occupations
    # searchableAttributes ['unordered(title)', 'unordered(description)']
  end

  def self.platform_name_stylized(tag)
    name = {
      'macos' => 'macOS',
      'ios' => 'iOS',
      'api' => 'API',
      'iphone' => 'iPhone',
      'ipad' => 'iPad',
    }[tag]
    return name.nil? ? tag.titleize : name
  end


  def self.fix_industry_solution_votes
    Solution.all.each do |s|
      s.industry_solutions.each do |is|
        is.solution_votes = s.cached_votes_score
        is.save
      end
      s.occupation_solutions.each do |os|
        os.solution_votes = s.cached_votes_score
        os.save
      end
    end
  end

  def tags
    self.niche_specific_tag_list + self.general_tag_list
  end



  def created_by_user?
    self.is_creator
  end

  def normalize_friendly_id(string)
    super[0..49]
  end

  def niche_list
    self.industries + self.occupations
  end

  def niche_list=(codes)
    # byebug
    industries = []
    occupations = []
    # byebug
    codes.delete_if(&:blank?).map do |code|
      if industry = Industry.where(code: code).first
        industries << industry
      elsif occupation = Occupation.where(code: code).first
        occupations << occupation
      end
    end
    self.industries = industries
    self.occupations = occupations
  end

  def group_list
    self.groups.pluck(:title)
  end

  def group_list=(group_titles)
    groups = []
    group_titles.delete_if(&:blank?).map do |title|
      if group = Group.where(title: title).first
        groups << group
      else
        group = Group.new(title: title)
        groups << group
      end
    end
    self.groups = groups
  end

  # def post_to_industry(industry)
  #   industries << industry
  # end

  # def post_to_occupation(occupation)
  #   occupations << occupation
  # end

  private

  def user_confirmed
    self.user.confirmed?
  end

  def user_confirmed_changed?
    self.user.confirmed_at_changed?
  end


  def _tags_changed?
    general_tag_list_changed?
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def url
    Rails.application.routes.url_helpers.solution_path(self.slug)
  end

  def communities_for_search
    industries = self.industries.map do |i|
      { title: i.title, keywords: i.keyword_list, type: "Industry" }
    end

    occupations = self.occupations.map do |o|
      { title: o.title, keywords: o.keyword_list, type: "Occupation" }
    end

    industries + occupations
  end

  def plan_for_search
    price = plan.price_per_month.to_f;
    plan.nil? ? {} : {
      name: plan.name,
      # price_per_user_per_month: plan.is_price_per_user ? price : nil,
      # price_per_month: plan.is_price_per_user ? nil : price,
      price: price,
      is_price_per_user: plan.is_price_per_user,
      price_facet: plan.is_price_per_user ? "Per user per month" : "Per month",
      is_for_education: plan.is_for_education,
      is_free: price == 0
    }

  end



  def url_changed?
    true || slug_changed?
  end

  def remake_slug
    base_slug = normalize_friendly_id(self.title)
    if self.slug != base_slug
      self.slug = "#{base_slug}-#{self.id}"
      self.save
    end
  end

  def check_if_product_exists(product_attr)
    # User has selected an existing product so both fields are blank
    if product_attr['name'].blank? && product_attr['thumbnail_url'].blank? && !product_attr['id'].blank?
      if _product = Product.find(product_attr['id'])
        self.product = _product
        return true
      else
        return false
      end
    end

    # One field blank means user hasn't filled out form properly (user error)
    if product_attr['name'].blank? || product_attr['thumbnail_url'].blank?
      return true
    end

    return false
  end

  def check_if_plan_exists(plan_attr)
    # User has selected an existing product so both fields are blank
    if plan_attr['name'].blank? && plan_attr['price_per_month'].blank? && !plan_attr['id'].blank?
      if _plan = Plan.find(plan_attr['id'])
        self.plan = _plan
        return true
      else
        return false
      end
    end

    # One field blank means user hasn't filled out form properly (user error)
    if plan_attr['name'].blank? || plan_attr['price_per_month'].blank?
      return true
    end

    return false
  end

  def atleast_one_niche
    if industries.empty? && occupations.empty?
      errors.add(:communities, "can't be empty")
    end
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end


  def assign_description_safe_html
    assign_attributes({
      description_safe_html: self.class.markdown.render(description.gsub(/\n/, "&nbsp;\n"))
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
