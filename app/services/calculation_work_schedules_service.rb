class CalculationWorkSchedulesService

  def self.calculation(year, month, days, admin, employees)
    work_patterns = WorkPattern.where(company_id: admin.company.id)
    date = Date.new(year, month, 1)
    calc_schedules = []

    # continuous_work 連勤カウント
    # total_work 出勤日数の合計
    days.times do |i|
      schedule = schedule_format(admin, employees)
      schedule.each_value do |value|
        value[:work_date] = date + i
      end
      pattern_member = pattern_member_format(admin, employees, work_patterns)
      except_member = []
      pattern_member.each do |key, value|
        unless except_member.empty?
          except_member.each do |v|
            value.delete(v)
          end
        end
        pattern = WorkPattern.find(key.to_s)
        num = value.length
        result = value[rand(num)]
        schedule[result.to_s.to_sym][:work_start_time] = pattern.start_time
        schedule[result.to_s.to_sym][:work_end_time] = pattern.end_time
        except_member << result
        puts result
      end
      schedule.each do |key, value|
        calc_schedules << value
      end
    end
    return calc_schedules
  end

  def self.schedule_format(admin, employees)
    schedule = {}
    schedule[admin.number.to_sym] = {
      work_date: "",
      work_start_time: "",
      work_end_time: "",
      admin_id: admin.id,
      employee_id: ""
    }
    employees.each do |employee|
      schedule[employee.number.to_sym] = {
        work_date: "",
        work_start_time: "",
        work_end_time: "",
        admin_id: "",
        employee_id: employee.id
      }
    end
    return schedule
  end

  def self.pattern_member_format(admin, employees, work_patterns)
    pattern_member = {}
    work_patterns.each do |pattern|
      pattern_member[pattern.id.to_s.to_sym] = []
      search = AdminWorkPattern.find_by(admin_id: admin.id, work_pattern_id: pattern.id)
      if search.present?
        pattern_member[pattern.id.to_s.to_sym] << admin.number
      end
      employees.each do |employee|
        search = EmployeeWorkPattern.find_by(employee_id: employee.id, work_pattern_id: pattern.id)
        if search.present?
          pattern_member[pattern.id.to_s.to_sym] << employee.number
        end
      end
    end
    pattern_member.sort_by{ |key, value| value.length }
    return pattern_member
  end

end