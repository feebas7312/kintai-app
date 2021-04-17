class WorkSchedule < ApplicationRecord
  belongs_to :admin, optional: true
  belongs_to :employee, optional: true

  with_options presence: true do
    validates :work_date
    validates :start_time, format: { with: /\A\d{4}\z/, message: '半角数字4桁で入力してください' }, if: :end_time?
    validates :end_time, format: { with: /\A\d{4}\z/, message: '半角数字4桁で入力してください' }, if: :start_time?
  end

  validates :admin_id, presence: true, unless: :employee_id?
  validates :admin_id, absence: true, if: :employee_id?
  validates :employee_id, presence: true, unless: :admin_id?
  validates :employee_id, absence: true, if: :admin_id?
  validates :break_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999, message: 'の入力が正しくありません' }, if: :break_time?
  validates :work_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 660, message: 'が不正です' }
  validate :break_time_validation

  def break_time_validation
    return if break_time.blank?
    if work_time > 480 && break_time < 60
      errors.add(:break_time, 'は60分以上に設定してください')
    elsif work_time > 360 && break_time < 45
      errors.add(:break_time, 'は45分以上に設定してください')
    end
  end
end
