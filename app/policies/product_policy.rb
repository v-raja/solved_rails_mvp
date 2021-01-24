class ProductPolicy
  attr_reader :user, :product

  def initialize(user, product)
    @user = user
    @product = product
  end

  def show?
    true
  end

  def index?
    true
  end
end
