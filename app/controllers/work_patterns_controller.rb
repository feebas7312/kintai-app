class WorkPatternsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_company

  def new
    @work_pattern = WorkPattern.new
  end

  def create
    @work_pattern = WorkPattern.new(work_pattern_params)
    if @work_pattern.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @work_pattern = WorkPattern.find(params[:id])
    if @work_pattern.destroy
      redirect_to root_path
    else
      @admin = Admin.find(current_admin.id)
      @employees = Employee.where(admin_id: @admin.id)
      @work_patterns = WorkPattern.where(company_id: @company.id)
      render root_path
    end
  end

  private

  def work_pattern_params
    params.require(:work_pattern).permit(:start_time, :end_time, :break_time, :work_time).merge(company_id: params[:company_id])
  end

  def set_company
    @company = Company.find(params[:company_id])
  end
end
