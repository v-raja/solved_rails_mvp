class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized, except: [:show, :niche_index], unless: :devise_controller?
  before_action :set_current_user_id
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?

  protected

  def set_current_user_id
    gon.current_user_id = user_signed_in? ? current_user.id : nil
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :bio, :thumbnail_url, ])
  end

  private
  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an
  #    infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    before_sign_in_path = stored_location_for(resource_or_scope)
    before_sign_in_path.nil? ? super : before_sign_in_path
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    title = t "#{policy_name}.#{exception.query}.title", scope: "pundit", default: (t "default.title", scope: "pundit")
    body = t "#{policy_name}.#{exception.query}.body", scope: "pundit", default: (t "default.body", scope: "pundit")
    flash[:error] = {title: title, body: body}
    redirect_to(request.referrer || root_path)
  end
end
