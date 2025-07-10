class ApplicationController < ActionController::Base
  helper_method :current_cart
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def current_cart
    return unless user_signed_in?
    @current_cart ||= current_user.cart || current_user.create_cart
  end

  protected

  # ✅ This is critical for allowing `name` through Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
