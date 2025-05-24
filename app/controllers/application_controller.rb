class ApplicationController < ActionController::Base
   before_action :authenticate_user!
   
   before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    # for  /users (sign-up)
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:username, :private]
    )

    # for  /users (PUT/PATCH update)
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:username, :private]
    )
  end
end
