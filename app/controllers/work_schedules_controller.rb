class WorkSchedulesController < ApplicationController
  def new
    # @admin = Admin.find(current_admin.id)
    # @employees = Employee.where(admin_id: @admin.id)
    # @year = Date.today.year
    # @month = Date.today.month
    # @days = Date.today.end_of_month.day
    @admin = Admin.find(current_admin.id)
    @employees = Employee.where(admin_id: @admin.id)
    if params["search_date(1i)"].nil? || params["search_date(2i)"].nil?
      @year = Date.today.year
      @month = Date.today.month
      @days = Date.today.end_of_month.day
      @works = SearchWorkSchedulesService.search(@year, @month)
    elsif params["search_date(1i)"].empty? || params["search_date(2i)"].empty?
      flash[:alert] = '⚠️⚠️⚠️ 年と月を入力してください ⚠️⚠️⚠️'
      redirect_back fallback_location: :search
    else
      @year = params["search_date(1i)"].to_i
      @month = params["search_date(2i)"].to_i
      @days = Date.new(@year, @month, -1).day
      @works = SearchWorkSchedulesService.search(@year, @month)
    end
  end

  def search
    @admin = Admin.find(current_admin.id)
    @employees = Employee.where(admin_id: @admin.id)
    if params["search_date(1i)"].nil? || params["search_date(2i)"].nil?
      @year = Date.today.year
      @month = Date.today.month
      @days = Date.today.end_of_month.day
      @works = SearchWorkSchedulesService.search(@year, @month)
    elsif params["search_date(1i)"].empty? || params["search_date(2i)"].empty?
      flash[:alert] = '⚠️⚠️⚠️ 年と月を入力してください ⚠️⚠️⚠️'
      redirect_back fallback_location: :search
    else
      @year = params["search_date(1i)"].to_i
      @month = params["search_date(2i)"].to_i
      @days = Date.new(@year, @month, -1).day
      @works = SearchWorkSchedulesService.search(@year, @month)
    end
  end
end
