class Users::RegistrationsController < Devise::RegistrationsController


  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    attributes = account_update_params.clone
    if attributes[:thumbnail_url].blank?
      attributes[:thumbnail_url] = resource.thumbnail_url
    end

    resource_updated = update_resource(resource, attributes)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # def after_inactive_sign_up_path_for(resource)
  #   after_signup_path(":)")
  # end


  def after_sign_up_path_for(resource)
    after_signup_path(":)")
  end
end
