class CalculationWorkSchedulesService

  def self.calculation(year, month, days, admin, employees)
    work_patterns = WorkPattern.where(company_id: admin.company.id)
    date = Date.new(year, month, 1)
    calc_schedules = []
    consecutive_work = consecutive_work_format(admin, employees)

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
            2.times do
              probability_member << mem
            end
          elsif int == 4
            probability_member << mem
          end
        end

        pattern = WorkPattern.find(key.to_s)
        num = probability_member.length
        result = probability_member[rand(num)]
        schedule[result.to_s.to_sym][:work_start_time] = pattern.start_time
        schedule[result.to_s.to_sym][:work_end_time] = pattern.end_time
        except_member << result
      end

      schedule.each do |key, value|
        if value[:work_start_time] == "" && value[:work_end_time] == ""
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
      work_start_time: "",
      work_end_time: "",
      admin_id: admin.id
    }
    employees.each do |employee|
      schedule[employee.number.to_sym] = {
        work_date: "",
        work_start_time: "",
        work_end_time: "",
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