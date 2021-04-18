class WorkScheduleCollection
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  attr_accessor :collection

  def initialize(days, admin, employees, attributes = [])
    if attributes.present?
      self.collection = attributes.map do |value|
        WorkSchedule.new(
          id: value['id'],
          work_date: value['work_date'],
          start_time: value['start_time'],
          end_time: value['end_time'],
          break_time: value['break_time'],
          work_time: value['work_time'],
          admin_id: value['admin_id'],
          employee_id: value['employee_id']
        )
      end
    else
      members = employees.length + 1
      work_num = days.to_i * members
      self.collection = work_num.times.map{ WorkSchedule.new }
    end
  end

  def persisted?
    false
  end

  def save
    error_count = 0
    ## 既に一度作成されていればupdate、なければcreateする
    result = WorkSchedule.import collection, on_duplicate_key_update: [:start_time, :end_time, :break_time, :work_time], all_or_none: true
    raise ActiveRecord::RecordInvalid unless result.failed_instances.blank?
    rescue
      error_count = result.failed_instances.count
    ensure
      return error_count
  end
end