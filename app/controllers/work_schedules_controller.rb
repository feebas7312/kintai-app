class WorkSchedulesController < ApplicationController
  before_action :authenticate_admin!, except: [:index]
  before_action :authenticate_employee!, only: [:index], unless: proc { admin_signed_in? || employee_signed_in? }

  def index
    delete_old_data
    @admin = Admin.find(current_admin.id) if admin_signed_in?
    @admin = Admin.find(current_employee.admin_id) if employee_signed_in?
    @start_day = @admin.company.cutoff_date.next_day
    if params["search_date(1i)"].nil? || params["search_date(2i)"].nil?
      @year = Date.today.year
      @month = Date.today.month
      @days = Date.today.end_of_month.day
    elsif params["search_date(1i)"].empty? || params["search_date(2i)"].empty?
      flash[:error] = '⚠️⚠️⚠️ 年と月を入力してください ⚠️⚠️⚠️'
      return redirect_back fallback_location: :search
    else
      @year = params["search_date(1i)"].to_i
      @month = params["search_date(2i)"].to_i
      @days = Date.new(@year, @month, -1).day
    end
    get_date
    get_week_days
    @employees = Employee.where("(admin_id = ?) and (joining_date < ?)", @admin.id, Date.new(@year, @month, @start_day))
    @exist_schedules = SearchWorkSchedulesService.search(@year, @month, @days, @start_day, @admin, @employees)
  end

  def new
    @admin = Admin.find(current_admin.id)
    @start_day = @admin.company.cutoff_date.next_day
    if params["search_date(1i)"].nil? || params["search_date(2i)"].nil?
      @year = Date.today.year
      @month = Date.today.month
      @days = Date.today.end_of_month.day
    elsif params["search_date(1i)"].empty? || params["search_date(2i)"].empty?
      flash[:error] = '⚠️⚠️⚠️ 年と月を入力してください ⚠️⚠️⚠️'
      return redirect_back fallback_location: :new
    else
      @year = params["search_date(1i)"].to_i
      @month = params["search_date(2i)"].to_i
      @days = Date.new(@year, @month, -1).day
    end
    get_date
    get_week_days
    @employees = Employee.where("(admin_id = ?) and (joining_date < ?)", @admin.id, Date.new(@year, @month, @start_day))
    @work_schedules = WorkScheduleCollection.new(@days, @admin, @employees)
    @exist_schedules = SearchWorkSchedulesService.search(@year, @month, @days, @start_day, @admin, @employees)
  end

  def create
    @admin = Admin.find(current_admin.id)
    @start_day = @admin.company.cutoff_date.next_day
    @year = params["work_schedule_collection"][:year].to_i
    @month = params["work_schedule_collection"][:month].to_i
    @days = Date.new(@year, @month, -1).day
    @employees = Employee.where("(admin_id = ?) and (joining_date < ?)", @admin.id, Date.new(@year, @month, @start_day))
    @work_schedules = WorkScheduleCollection.new(@days, @admin, @employees, work_schedule_collection_params)
    if @work_schedules.save
      redirect_to new_work_schedule_path("search_date(1i)"=>@year, "search_date(2i)"=>@month)
    else
      redirect_back fallback_location: :new
    end
  end

  def destroy
    @admin = Admin.find(current_admin.id)
    @start_day = @admin.company.cutoff_date.next_day
    @year = params[:year].to_i
    @month = params[:month].to_i
    @days = params[:days].to_i
    @employees = Employee.where("(admin_id = ?) and (joining_date < ?)", @admin.id, Date.new(@year, @month, @start_day))
    @exist_schedules = SearchWorkSchedulesService.search(@year, @month, @days, @start_day, @admin, @employees)
    if @exist_schedules.delete_all
      redirect_to new_work_schedule_path
    else
      redirect_back fallback_location: :new
    end
  end

  def calculation
    @admin = Admin.find(current_admin.id)
    @start_day = @admin.company.cutoff_date.next_day
    @year = params[:year].to_i
    @month = params[:month].to_i
    @days = params[:days].to_i
    get_date
    get_week_days
    @employees = Employee.where("(admin_id = ?) and (joining_date < ?)", @admin.id, Date.new(@year, @month, @start_day))
    @exist_schedules = SearchWorkSchedulesService.search(@year, @month, @days, @start_day, @admin, @employees)
    @work_schedules = WorkScheduleCollection.new(@days, @admin, @employees)
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

  def get_date
    @date = []
    @days.times do |i|
      @date << Date.new(@year, @month, @start_day) + i
    end
    @wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
  end

  def delete_old_data
    WorkSchedule.where("work_date < ?", Date.today - 2.years).delete_all
  end

  def get_week_days
    @week_days = []
    4.times do |i|
      if i==3
        @week_days << @days - 21
      else
        @week_days << 7
      end
    end
  end
end
