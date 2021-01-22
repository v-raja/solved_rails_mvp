class SolutionPolicy
  attr_reader :user, :solution

  def initialize(user, solution)
    @user = user
    @solution = solution
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
    @user.present? && @solution && (@solution.user == @user || @user.admin?)
  end

  def create?
    @user.present?
  end

  def destroy?
    @user.present? && @user.admin?
  end
end
