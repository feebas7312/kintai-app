class EmployeesHomeController < ApplicationController

  def index
    @admin = Admin.find(current_employee.admin_id)
    @employees = Employee.where(admin_id: @admin.id)
  end

end
