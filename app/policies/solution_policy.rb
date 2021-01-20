class SolutionPolicy
  attr_reader :user, :solution

  def initialize(user, solution)
    @user = user
    @solution = solution
  end

  def upvote?
    !user.nil?
  end

  def remove_upvote?
    !user.nil?
  end

  def edit?
    user && (solution.user == user || user.admin?)
  end

  def new?
    user
  end

  def update?
    (solution.user == user) || user.admin?
  end

  def create?
    user
  end

  def destroy?
    user.admin?
  end
end
