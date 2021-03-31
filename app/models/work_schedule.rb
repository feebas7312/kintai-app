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
end
