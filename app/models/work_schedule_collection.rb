class WorkScheduleCollection
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  #WORK_NUM = 28 # 同時に生成するレコード数
  # NUM = WORK_NUM * 5
  attr_accessor :collection

  def initialize(days, admin, attributes = [])
    if attributes.present?
      self.collection = attributes.map do |value|
        WorkSchedule.new(
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
    ActiveRecord::Base.transaction do
      collection.each do |result|
        # バリデーションを全てかけたいからsave!ではなくsaveを使用
        is_success = false unless result.save
      end
      # バリデーションエラーがあった時は例外を発生させてロールバックさせる
      raise ActiveRecord::RecordInvalid unless is_success
    end
    rescue
      p 'エラー'
    ensure
      return is_success
  end
end