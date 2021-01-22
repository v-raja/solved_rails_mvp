class RequestPolicy
  attr_reader :user, :request

  def initialize(user, request)
    @user = user
    @request = request
  end

  def follow?
    @user.present?
  end

  def unfollow?
    @user.present?
  end

  def upvote?
    @user.present?
  end

  def remove_upvote?
    @user.present?
  end

  def edit?
    update?
  end

  def new?
    create?
  end

  def update?
    @user.present? && @request && (@request.user == @user || @user.admin?)
  end

  def create?
    true
  end

  def destroy?
    @user.present? && @user.admin?
  end
end
