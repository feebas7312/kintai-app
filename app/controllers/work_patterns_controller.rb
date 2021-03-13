class WorkPatternsController < ApplicationController
  before_action :authenticate_admin!

  def new
    @work_pattern = WorkPattern.new
    @company = Company.find(params[:company_id])
  end

  def create
    @work_pattern = WorkPattern.new(work_pattern_params)
    @company = Company.find(params[:company_id])
    if @work_pattern.save
      redirect_to company_path(current_admin)
    else
      render :new
    end
  end

  def destroy
    @work_pattern = WorkPattern.find(params[:id])
    if @work_pattern.destroy
      redirect_to company_path(current_admin)
    else
      render company_path(current_admin)
    end
  end

  private

  def work_pattern_params
    params.require(:work_pattern).permit(:start_time, :end_time).merge(company_id: params[:company_id])
  end
end
