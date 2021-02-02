class ConfirmationsController < Devise::ConfirmationsController

  private

  def after_confirmation_path_for(resource_name, resource)
    # If name is nil then they've only subscribed to get notifs
    # If name is not nil, they've signed up or created a post
    # if params[:for_notifs]
    #   sign_out resource
    #   root_path
    # else

    # end
    sign_in(resource_name, resource)
    after_signup_path(":)")
  end

end
