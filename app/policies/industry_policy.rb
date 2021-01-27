class IndustryPolicy
  attr_reader :user, :industry

  def initialize(user, industry)
    @user = user
    @industry = industry
  end

  def follow?
    # @user.present?
    true
  end

  def unfollow?
    @user.present?
  end

end
