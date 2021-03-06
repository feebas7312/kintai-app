class CompaniesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin

  def show
    @employees = Employee.where(admin_id: @admin.id)
    @work_patterns = WorkPattern.where(company_id: @company.id)
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to company_path(current_admin)
    else
      render :edit
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :postal_code, :address, :phone_number, :cutoff_date_id, :opening_time, :closing_time).merge(admin_id: current_admin.id)
  end

  def set_admin
    @admin = Admin.find(current_admin.id)
    @company = @admin.company
  end
end
