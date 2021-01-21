class IndustryPolicy
  attr_reader :user, :request

  def initialize(user, industry)
    @user = user
    @industry = industry
  end

  def follow?
    @user.present?
  end

  def unfollow?
    @user.present?
  end

end
