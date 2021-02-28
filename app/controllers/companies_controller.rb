class CompaniesController < ApplicationController
  def show
    @admin = Admin.find(params[:id])
    @employees = Employee.where(admin_id: @admin.id)
    @company = @admin.company
    @work_patterns = WorkPattern.where(company_id: @company.id)
  end

  def edit
    @admin = Admin.find(params[:id])
    @company = @admin.company
  end

  def update
    @admin = Admin.find(params[:id])
    @company = @admin.company
    if @company.update(company_params)
      redirect_to company_path(current_admin)
    else
      render :edit
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :opening_time, :closing_time).merge(admin_id: current_admin.id)
  end
end
