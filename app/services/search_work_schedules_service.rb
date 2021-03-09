class SearchWorkSchedulesService
  def self.search(year, month, days, start_day, admin, employees)
    start_date = Date.new(year, month, start_day)
    end_date = start_date + days - 1

    employee_ids = []
    employees.each do |employee|
      employee_ids << employee.id
    end

    WorkSchedule.where(work_date: start_date..end_date, admin_id: admin.id).or(WorkSchedule.where(work_date: start_date..end_date, employee_id: employee_ids))
  end
end