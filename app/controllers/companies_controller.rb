class CompaniesController < ApplicationController
  def show
    @admin = Admin.find(params[:id])
    @company = @admin.company
  end
end
