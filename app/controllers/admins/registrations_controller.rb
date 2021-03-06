# frozen_string_literal: true

class Admins::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  def create
    @admin = Admin.new(sign_up_params)
    unless @admin.valid?
      render :new and return
    end
    session["devise.regist_data"] = {admin: @admin.attributes}
    session["devise.regist_data"][:admin]["password"] = params[:admin][:password]
    @company = @admin.build_company
    render :new_company
  end

  def create_company
    @admin = Admin.new(session["devise.regist_data"]["admin"])
    @company = Company.new(company_params)
    unless @company.valid?
      render :new_company and return
    end
    @admin.build_company(@company.attributes)
    @admin.save
    session["devise.regist_data"]["admin"].clear
    sign_in(:admin, @admin)
    redirect_to root_path
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:number, :last_name, :first_name, :birth_date, :phone_number, :email, :joining_date, :employment_status_id, :salary_system_id, :wages])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:number, :last_name, :first_name, :birth_date, :phone_number, :email, :joining_date, :employment_status_id, :salary_system_id, :wages])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def company_params
    params.require(:company).permit(:name, :postal_code, :address, :phone_number, :cutoff_date_id, :opening_time, :closing_time)
  end

  def after_update_path_for(resource)
      admins_home_path(current_admin)
  end
end
