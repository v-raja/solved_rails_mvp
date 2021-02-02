class SuggestedKeywordPolicy
  attr_reader :user, :suggested_keyword

  def initialize(user, suggested_keyword)
    @user = user
    @suggested_keyword = suggested_keyword
  end

  def create?
    true
  end

  def destroy?
    @user && @user.admin?
  end
end
