# frozen_string_literal: true

class Employees::SessionsController < Devise::SessionsController
  before_action :move_to_admin_home, if: proc { admin_signed_in? }
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def after_sign_in_path_for(resource)
    employees_home_path(current_employee)
  end

  def move_to_admin_home
    redirect_to root_path
  end
end
