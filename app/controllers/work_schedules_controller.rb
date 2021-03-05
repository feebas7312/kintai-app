class WorkSchedulesController < ApplicationController
  def new
    @admin = Admin.find(current_admin.id)
    @employees = Employee.where(admin_id: @admin.id)
    if params["search_date(1i)"].nil? || params["search_date(2i)"].nil?
      @year = Date.today.year
      @month = Date.today.month
      @days = Date.today.end_of_month.day
      @exist_schedules = SearchWorkSchedulesService.search(@year, @month)
    elsif params["search_date(1i)"].empty? || params["search_date(2i)"].empty?
      flash[:alert] = '⚠️⚠️⚠️ 年と月を入力してください ⚠️⚠️⚠️'
      redirect_back fallback_location: :new
    else
      @year = params["search_date(1i)"].to_i
      @month = params["search_date(2i)"].to_i
      @days = Date.new(@year, @month, -1).day
      @exist_schedules = SearchWorkSchedulesService.search(@year, @month)
    end
    @work_schedules = WorkScheduleCollection.new(@days, @admin)
  end

  def create
    @admin = Admin.find(current_admin.id)
    @employees = Employee.where(admin_id: @admin.id)
    @year = params["work_schedule_collection"][:year].to_i
    @month = params["work_schedule_collection"][:month].to_i
    @days = Date.new(@year, @month, -1).day
    @work_schedules = WorkScheduleCollection.new(@days, @admin, work_schedule_collection_params)
    if @work_schedules.save
      redirect_to new_work_schedule_path("search_date(1i)"=>@year, "search_date(2i)"=>@month)
    else
      redirect_back fallback_location: :new
    end
  end

  def search
    @admin = Admin.find(current_admin.id) if admin_signed_in?
    @admin = Admin.find(current_employee.admin_id) if employee_signed_in?
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

  def calculation
    @admin = Admin.find(current_admin.id)
    @employees = Employee.where(admin_id: @admin.id)
    @year = params[:year].to_i
    @month = params[:month].to_i
    @days = params[:days].to_i
    @exist_schedules = SearchWorkSchedulesService.search(@year, @month)
    @work_schedules = WorkScheduleCollection.new(@days, @admin)
    @calc_schedules = CalculationWorkSchedulesService.calculation(@year, @month, @days, @admin, @employees)
    unless @calc_schedules
      flash[:alert] = '⚠️⚠️⚠️ 登録パターンに対して従業員数が足りません ⚠️⚠️⚠️'
      redirect_back fallback_location: :new
    end
  end

  private

  def work_schedule_collection_params
    params.require(:work_schedules)
  end
end
