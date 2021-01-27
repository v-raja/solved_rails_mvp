# == Schema Information
#
# Table name: comments
#
#  id                      :bigint           not null, primary key
#  commentable_id          :integer
#  commentable_type        :text
#  title                   :text
#  body                    :text
#  body_safe_html          :text
#  subject                 :text
#  user_id                 :integer          not null
#  parent_id               :integer
#  lft                     :integer
#  rgt                     :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  discarded_at            :datetime
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  comments_count          :integer          default(0), not null
#
class Comment < ActiveRecord::Base
  class << self
    def markdown
      Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(no_images: true, no_styles: true, safe_links_only: true, hard_wrap: true, filter_html: true), auto_link: true, no_intra_emphasis: true, strikethrough: true)
    end
  end

  include Discard::Model

  before_save :assign_body_safe_html , if: -> { body_changed? || body_safe_html.nil? }
  before_save :anti_spam, if: -> { body_safe_html_changed? }

  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates :body, :presence => true
  validates :user, :presence => true

  acts_as_votable

  belongs_to :commentable, :polymorphic => true, touch: true
  counter_culture :commentable, column_name: "comments_count"
  # NOTE: Comments belong to a user
  belongs_to :user


  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    new \
      :commentable => obj,
      :body        => comment,
      :user_id     => user_id
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.any?
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  private

  def assign_body_safe_html
    assign_attributes({
      body_safe_html: self.class.markdown.render(body.gsub(/\n/, '&nbsp;'))
    })
  end

  def anti_spam
    doc = Nokogiri::HTML::DocumentFragment.parse(self.body_safe_html)
    doc.css('a').each do |a|
      a[:rel] = 'nofollow ugc noopener'
      a[:target] = '_blank'
      a[:class] = 'user-link'
    end
    self.body_safe_html = doc.to_s
  end

end
