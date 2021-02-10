class Users::SessionsController < Devise::SessionsController

  # def after_sign_in_path_for(resource_or_scope)
  #   gon.ffi = Base64.encode64(JSON.dump(resource_or_scope.traits))
  #   gon.pxmalz = Base64.encode64(resource_or_scope.id.to_s)
  #   byebug
  #   super
  # end

end
