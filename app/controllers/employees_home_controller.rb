class EmployeesHomeController < ApplicationController
  def index
  end

  def show
    @admin = Admin.find(current_employee.admin_id)
    @employees = Employee.where(admin_id: @admin.id)
  end
end
