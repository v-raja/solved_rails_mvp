class CommentPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def upvote?
    @user.present?
  end

  def remove_upvote?
    @user.present?
  end

  def create?
    @user.present?
  end

  def destroy?
    @user.present?
  end

  def restore?
    @user.present? && @user.admin?
  end

  def really_destroy?
    @user.present? && @user.admin?
  end
end
