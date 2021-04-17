class CalculationWorkSchedulesService

  def self.calculation(year, month, days, start_day, admin, employees)
    work_patterns = WorkPattern.where(company_id: admin.company.id)
    calc_schedules = []
    consecutive_work = consecutive_work_format(admin, employees)

    days.times do |i|
      schedule = schedule_format(admin, employees)
      schedule.each_value do |value|
        value[:work_date] = Date.new(year, month, start_day)+i
      end
      pattern_member = pattern_member_format(admin, employees, work_patterns)
      except_member = []

      pattern_member.each do |key, value|
        unless except_member.empty?
          except_member.each do |v|
            value.delete(v)
          end
        end

        probability_member = []
        value.each do |mem|
          int = consecutive_work[mem.to_sym]
          if int == 0
            5.times do
              probability_member << mem
            end
          elsif int == 1
            4.times do
              probability_member << mem
            end
          elsif int == 2
            3.times do
              probability_member << mem
            end
          elsif int == 3
            # 2.times do
              probability_member << mem
            # end
          # elsif int == 4
          #   probability_member << mem
          end
        end

        begin
          pattern = WorkPattern.find(key.to_s)
          num = probability_member.length
          result = probability_member[rand(num)]
          schedule[result.to_s.to_sym][:start_time] = pattern.start_time
          schedule[result.to_s.to_sym][:end_time] = pattern.end_time
          schedule[result.to_s.to_sym][:break_time] = pattern.break_time
          schedule[result.to_s.to_sym][:work_time] = pattern.work_time
          except_member << result   
        rescue => exception
          return false
        end
      end

      schedule.each do |key, value|
        if value[:start_time] == "" && value[:end_time] == ""
          consecutive_work[key] = 0
        else
          consecutive_work[key] += 1
        end
        calc_schedules << value
      end
    end
    return calc_schedules
  end

  private

  def self.consecutive_work_format(admin, employees)
    consecutive_work = {}
    consecutive_work[admin.number.to_sym] = 0
    employees.each do |employee|
      consecutive_work[employee.number.to_sym] = 0
    end
    return consecutive_work
  end

  def self.schedule_format(admin, employees)
    schedule = {}
    schedule[admin.number.to_sym] = {
      work_date: "",
      start_time: "",
      end_time: "",
      break_time: "",
      work_time: "",
      admin_id: admin.id
    }
    employees.each do |employee|
      schedule[employee.number.to_sym] = {
        work_date: "",
        start_time: "",
        end_time: "",
        break_time: "",
        work_time: "",
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