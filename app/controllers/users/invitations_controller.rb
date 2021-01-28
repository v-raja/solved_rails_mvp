class Users::InvitationsController < Devise::InvitationsController

  # def after_accept_path_for(resource)
  #   after_signup_path(":)")
  # end


  before_action :update_sanitized_params, only: :update

  # PUT /resource/invitation
  def update
    respond_to do |format|
      format.js do
        invitation_token = Devise.token_generator.digest(resource_class, :invitation_token, update_resource_params[:invitation_token])
        self.resource = resource_class.where(invitation_token: invitation_token).first

        resource.skip_password = true
        resource.update_attributes update_resource_params.except(:invitation_token)
      end
      format.html do
        super
      end
    end
  end


  protected

  def update_resource_params
    paramz = devise_parameter_sanitizer.sanitize(:accept_invitation).clone
    if paramz[:thumbnail_url].blank?
      paramz[:thumbnail_url] = params[:user][:old_thumbnail_url]
    end
    paramz
  end

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name, :password, :invitation_token, :thumbnail_url, :bio])
  end
end
