class WorkSchedule < ApplicationRecord
  belongs_to :admin, optional: true
  belongs_to :employee, optional: true

  with_options presence: true do
    validates :work_date
    validates :start_time, format: { with: /\A\d{4}\z/, message: 'を半角数字4桁で入力してください' }, if: :end_time?
    validates :end_time, format: { with: /\A\d{4}\z/, message: 'を半角数字4桁で入力してください' }, if: :start_time?
  end

  validates :break_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999, message: 'の入力が正しくありません' }, allow_blank: true
  validates :work_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 660, message: 'が不正です' }
  validate :break_time_validation
  validate :staff_validation

  def break_time_validation
    if start_time.blank? || end_time.blank?
      return
    elsif break_time.blank? && start_time.present? && end_time.present?
      errors.add(:break_time, 'を入力してください')
    elsif work_time.blank?
      errors.add(:work_time, 'が不正です')
    elsif work_time > 480 && break_time < 60
      errors.add(:break_time, 'は60分以上に設定してください')
    elsif work_time > 360 && break_time < 45
      errors.add(:break_time, 'は45分以上に設定してください')
    end
  end

  def staff_validation
    if admin_id.blank? && employee_id.blank?
      errors.add(:admin_id, '誰の勤務計画かわかりません')
    elsif admin_id.present? && employee_id.present?
      errors.add(:employee_id, '2人のスタッフIDが紐付いています')
    end
  end
end
