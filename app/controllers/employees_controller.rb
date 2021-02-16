class EmployeesController < ApplicationController
  def show
    @employee = Employee.find(params[:employee_id])
    @admin = Admin.find(@employee.admin_id)
    @work_patterns = WorkPattern.where(company_id: @admin.company.id)
    @employee_work_patterns = EmployeeWorkPattern.where(employee_id: @employee.id)
    @new_pattern = EmployeeWorkPatternCollection.new(@work_patterns)
  end
end
