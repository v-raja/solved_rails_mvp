
class Track::User
  def initialize(user)
    @user = user
  end
  def logged_in_event(event, properties = {})
    identify_user
    TrackEventJob.perform_later(
      {
        user_id: @user.id,
        event: event,
        properties: properties
      }
    )
  end
  def logged_in
    identify_user
    TrackEventJob.perform_later(
      {
        user_id: @user.id,
        event: 'Sign In User'
      }
    )
  end
  def identify_user
    IdentifyUserJob.perform_later(
      {
        user_id: @user.id,
        traits: {
          email: @user.email,
          name: @user.name,
          # logins
          # createdAt
          # title
          # niche list
          # is creator - insights on their posts?
          #

          lastName: @user.last_name,
          logins: @user.sign_in_count,
          country: @user.country,
        }
      }
    )
  end
end
