class OccupationCategoryPolicy
  attr_reader :user, :occupation_category

  def initialize(user, occupation_category)
    @user = user
    @occupation_category = occupation_category
  end

  def show?
    true
  end

  def index?
    true
  end

end
