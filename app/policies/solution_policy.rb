class SolutionPolicy
  attr_reader :user, :solution

  def initialize(user, solution)
    @user = user
    @solution = solution
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
    @user && @solution && (@solution.user == @user || @user.admin?)
  end

  def create?
    @user
  end

  def destroy?
    @user.admin?
  end
end
