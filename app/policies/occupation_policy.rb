class OccupationPolicy
  attr_reader :user, :occupation

  def initialize(user, occupation)
    @user = user
    @occupation = occupation
  end

  def follow?
    true
  end

  def unfollow?
    @user.present?
  end

end
