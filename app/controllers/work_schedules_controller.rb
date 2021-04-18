class WorkSchedulesController < ApplicationController
  before_action :authenticate_admin!, except: [:index]
  before_action :authenticate_employee!, only: [:index], unless: proc { admin_signed_in? || employee_signed_in? }
  before_action :delete_old_data, only: [:index]

  def index
    search_date
    set_staff
    set_calendar
    set_week_days
    set_exist_schedules
  end

  def new
    search_date
    set_staff
    set_calendar
    set_week_days
    set_exist_schedules
    set_new_schedules_form
  end

  def create
    @year = params["work_schedule_collection"][:year].to_i
    @month = params["work_schedule_collection"][:month].to_i
    @days = Date.new(@year, @month, -1).day
    set_staff
    @temporary = WorkScheduleCollection.new(@days, @admin, @employees, work_schedule_collection_params)
    error_count = @temporary.save
    if error_count == 0
      redirect_to new_work_schedule_path("search_date(1i)"=>@year, "search_date(2i)"=>@month)
    else
      set_calendar
      set_week_days
      set_exist_schedules
      set_new_schedules_form
      flash.now[:error] = "⚠️⚠️⚠️ #{error_count}件の入力ミスがあります ⚠️⚠️⚠️"
      render :new
    end
  end

  def destroy
    set_date
    set_staff
    set_exist_schedules
    if @exist_schedules.delete_all
      redirect_to new_work_schedule_path("search_date(1i)"=>@year, "search_date(2i)"=>@month)
    else
      redirect_back fallback_location: :new
    end
  end

  def calculation
    set_date
    set_staff
    set_calendar
    set_week_days
    set_exist_schedules
    set_new_schedules_form
    @calc_schedules = CalculationWorkSchedulesService.calculation(@year, @month, @days, @start_day, @admin, @employees)
    unless @calc_schedules
      flash[:error] = '⚠️⚠️⚠️ 登録パターンに対して従業員数が足りません ⚠️⚠️⚠️'
      redirect_back fallback_location: :new
    end
  end

  private

  def work_schedule_collection_params
    params.require(:work_schedules)
  end

  def delete_old_data
    WorkSchedule.where("work_date < ?", Date.today - 2.years).delete_all
  end

  def search_date
    if params["search_date(1i)"].nil? || params["search_date(2i)"].nil?
      @year = Date.today.year
      @month = Date.today.month
      @days = Date.today.end_of_month.day
    elsif params["search_date(1i)"].empty? || params["search_date(2i)"].empty?
      flash.now[:error] = '⚠️⚠️⚠️ 年と月を入力してください ⚠️⚠️⚠️'
      @year = params[:year].to_i
      @month = params[:month].to_i
      @days = Date.new(@year, @month, -1).day
    else
      @year = params["search_date(1i)"].to_i
      @month = params["search_date(2i)"].to_i
      @days = Date.new(@year, @month, -1).day
    end
  end

  def set_date
    @year = params[:year].to_i
    @month = params[:month].to_i
    @days = params[:days].to_i
  end

  def set_staff
    @admin = Admin.find(current_admin.id) if admin_signed_in?
    @admin = Admin.find(current_employee.admin_id) if employee_signed_in?
    @start_day = @admin.company.cutoff_date.next_day
    @employees = Employee.where("(admin_id = ?) and (joining_date < ?)", @admin.id, Date.new(@year, @month, @start_day) >> 1)
  end

  def set_calendar   ## ビューで日付を出すときに使用
    @date = []
    @days.times { |i| @date << Date.new(@year, @month, @start_day) + i }
    @wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
  end

  def set_week_days   ## ビューのループ処理で使用
    @week_days = [7, 7, 7]
    @week_days << @days - 21
  end

  def set_new_schedules_form
    @work_schedules = WorkScheduleCollection.new(@days, @admin, @employees)
  end

  def set_exist_schedules
    @exist_schedules = SearchWorkSchedulesService.search(@year, @month, @days, @start_day, @admin, @employees)
  end
end
