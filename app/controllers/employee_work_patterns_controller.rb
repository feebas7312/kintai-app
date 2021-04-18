class EmployeeWorkPatternsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_staff
  before_action :set_work_patterns

  def new
    @new_pattern = EmployeeWorkPatternCollection.new(@work_patterns)
  end

  def create
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

  def set_staff
    @employee = Employee.find(params[:employee_id])
    @admin = Admin.find(@employee.admin_id)
  end

  def set_work_patterns
    @work_patterns = WorkPattern.where(company_id: @admin.company.id)
    @employee_work_patterns = EmployeeWorkPattern.where(employee_id: @employee.id)
  end
end
