class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:upvote, :remove_upvote]

  def upvote
    @comment.liked_by current_user
    respond_to do |format|
      format.js
    end
  end

  def remove_upvote
    @comment.unliked_by current_user
    respond_to do |format|
      format.js
    end
  end

  def create
    commentable = commentable_type.constantize.find(commentable_id)
    @comment = Comment.build_from(commentable, current_user.id, body)

    respond_to do |format|
      if @comment.save
        make_child_comment
        format.html  { redirect_back(fallback_location: root_path, :notice => 'Comment was successfully added.') }
      else
        format.html  { redirect_back(fallback_location: root_path, :notice => 'Comment not added.') }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :comment_id)
  end

  def commentable_type
    comment_params[:commentable_type]
  end

  def commentable_id
    comment_params[:commentable_id]
  end

  def comment_id
    comment_params[:comment_id]
  end

  def body
    comment_params[:body]
  end

  def make_child_comment
    return "" if comment_id.blank?

    parent_comment = Comment.find comment_id
    @comment.move_to_child_of(parent_comment)
  end

  def set_comment
    # @comment = Comment.find(comment_id)
    @comment = Comment.find(params[:id])
  end

end
