class FeedbackPolicy
  attr_reader :user, :feedback

  def initialize(user, feedback)
    @user = user
    @feedback = feedback
  end

  def create?
    true
  end

end
