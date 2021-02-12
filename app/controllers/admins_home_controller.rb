class AdminsHomeController < ApplicationController
  before_action :authenticate_admin!

  def index
    @admin = Admin.find(current_admin.id)
    @employees = Employee.where(admin_id: @admin.id)
  end

  def show
    @admin = Admin.find(params[:id])
    @employees = Employee.where(admin_id: @admin.id)
  end

  def destroy
    employee = Employee.find(params[:id])
    employee.destroy
    redirect_to root_path
  end
end
