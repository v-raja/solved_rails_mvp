class MiniRequestPolicy
  attr_reader :user, :mini_request

  def initialize(user, mini_request)
    @user = user
    @mini_request = mini_request
  end

  def create?
    true
  end

end
