class IndustryCategoryPolicy
  attr_reader :user, :industry_category

  def initialize(user, industry_category)
    @user = user
    @industry_category = industry_category
  end

  def show?
    true
  end

  def index?
    true
  end

end
