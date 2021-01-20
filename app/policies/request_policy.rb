class RequestPolicy
  attr_reader :user, :request

  def initialize(user, request)
    @user = user
    @request = request
  end

  def upvote?
    @user
  end

  def remove_upvote?
    @user
  end

  def edit?
    update?
  end

  def new?
    create?
  end

  def update?
    @user && @request && (@request.user == @user || @user.admin?)
  end

  def create?
    true
  end

  def destroy?
    @user.admin?
  end
end
