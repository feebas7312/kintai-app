class EmployeesHomeController < ApplicationController
  before_action :authenticate_employee!

  def index
  end

  def show
    @admin = Admin.find(current_employee.admin_id)
    @employees = Employee.where(admin_id: @admin.id)
  end
end
