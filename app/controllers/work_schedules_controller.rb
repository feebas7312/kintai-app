class WorkSchedulesController < ApplicationController
  def index
  end

  def search
    if params["search_date(1i)"].empty? || params["search_date(2i)"].empty?
      render :index
    else
      @admin = Admin.find(current_admin.id)
      @employees = Employee.where(admin_id: @admin.id)
      @year = params["search_date(1i)"].to_i
      @month = params["search_date(2i)"].to_i
      @days = Date.new(@year, @month, -1).day
      @works = SearchWorkSchedulesService.search(@year, @month)
    end
  end
end
