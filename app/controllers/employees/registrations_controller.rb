# frozen_string_literal: true

class Employees::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :require_no_authentication, only: [:cancel]
  prepend_before_action :authenticate_scope!, only: []
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    @employee = Employee.new(sign_up_params)
    if @employee.valid?
      @employee.save
      session[:employee_id] = nil
      redirect_to admins_home_path(current_admin)
    else
      render :new
    end
  end

  # GET /resource/edit
  def edit
    if admin_signed_in?
      # self.resource = Employee.find(params[:employee_id])
      self.resource = resource_class.to_adapter.get!(params[:employee_id])
    else
      authenticate_scope!
      super
    end
  end

  # PUT /resource
  def update
    if admin_signed_in?
      self.resource = resource_class.to_adapter.get!(params[:employee][:id])
    else
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    end

    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if admin_signed_in?
      resource_updated = update_resource_without_password(resource, account_update_params)
    else
      resource_updated = update_resource(resource, account_update_params)
    end

    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      unless admin_signed_in?
        bypass_sign_in resource, scope: resource_name
      end
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # DELETE /resource
  def destroy
    if admin_signed_in?
      @employee = Employee.find(params[:id])
      @employee.destroy
    end
    redirect_to admins_home_path(current_admin)
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:number, :last_name, :first_name, :birth_date, :phone_number, :email, :joining_date, :employment_status_id, :salary_system_id, :wages, :admin_id])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:number, :last_name, :first_name, :birth_date, :phone_number, :email, :joining_date, :employment_status_id, :salary_system_id, :wages])
  end

  def update_resource_without_password(resource, params)
    resource.update_without_password(params)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  def after_update_path_for(resource)
    if admin_signed_in?
      admins_home_path(current_admin)
    else
      employees_home_index_path
    end
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
