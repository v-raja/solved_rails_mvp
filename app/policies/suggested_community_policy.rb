class SuggestedCommunityPolicy
  attr_reader :user, :suggested_community

  def initialize(user, suggested_community)
    @user = user
    @suggested_community = suggested_community
  end

  def create?
    true
  end

  def destroy?
    @user && @user.admin?
  end
end
