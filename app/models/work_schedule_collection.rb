class WorkScheduleCollection
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  attr_accessor :collection

  def initialize(days, admin, attributes = [])
    if attributes.present?
      self.collection = attributes.map do |value|
        WorkSchedule.new(
          id: value['id'],
          work_date: value['work_date'],
          work_start_time: value['work_start_time'],
          work_end_time: value['work_end_time'],
          admin_id: value['admin_id'],
          employee_id: value['employee_id']
        )
      end
    else
      members = Employee.where(admin_id: admin.id).length+1
      work_num = days.to_i * members
      self.collection = work_num.times.map{ WorkSchedule.new }
    end
  end

  def persisted?
    false
  end

  def save
    is_success = true
    work_schedules = []
    is_success = false unless WorkSchedule.import collection, on_duplicate_key_update: [:work_start_time, :work_end_time], all_or_none: true
    raise ActiveRecord::RecordInvalid unless is_success
    rescue
      p 'エラー'
    ensure
      return is_success
  end
end