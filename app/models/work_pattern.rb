class WorkPattern < ApplicationRecord
  belongs_to :company
  has_many :admin_work_patterns, dependent: :destroy
  has_many :employee_work_patterns, dependent: :destroy

  validates :start_time, format: { with: /\A\d{4}\z/, message: 'を半角数字4桁で入力してください' }
  validates :end_time, format: { with: /\A\d{4}\z/, message: 'を半角数字4桁で入力してください' }
  validates :break_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999, message: 'の入力が正しくありません' }
  validates :work_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 660, message: 'が不正です' }
  validate :break_time_validation
  validates :company_id, presence: true

  def break_time_validation
    return if break_time.blank?
    if work_time > 480 && break_time < 60
      errors.add(:break_time, 'は60分以上に設定してください')
    elsif work_time > 360 && break_time < 45
      errors.add(:break_time, 'は45分以上に設定してください')
    end
  end
end
