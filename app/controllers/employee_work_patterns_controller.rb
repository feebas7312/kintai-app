class EmployeeWorkPatternsController < ApplicationController
  before_action :authenticate_admin!

  def new
    @employee = Employee.find(params[:employee_id])
    @admin = Admin.find(@employee.admin_id)
    @work_patterns = WorkPattern.where(company_id: @admin.company.id)
    @employee_work_patterns = EmployeeWorkPattern.where(employee_id: @employee.id)
    @new_pattern = EmployeeWorkPatternCollection.new(@work_patterns)
  end

  def create
    @employee = Employee.find(params[:employee_id])
    @admin = Admin.find(@employee.admin_id)
    @work_patterns = WorkPattern.where(company_id: @admin.company.id)
    @employee_work_patterns = EmployeeWorkPattern.where(employee_id: @employee.id)
    @new_pattern = EmployeeWorkPatternCollection.new(@work_patterns, employee_work_patterns_collection_params)
    if @new_pattern.save
      flash[:alert] = '登録しました'
      redirect_to new_employee_work_pattern_path(employee_id: @employee.id)
    else
      render new_employee_work_pattern_path
    end
  end

  private

  def employee_work_patterns_collection_params
    params.require(:employee_work_patterns)
  end
end
