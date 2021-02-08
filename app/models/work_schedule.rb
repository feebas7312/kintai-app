class WorkSchedule < ApplicationRecord
  belongs_to :admin, optional: true
  belongs_to :employee, optional: true

  with_options presence: true do
    validates :work_date
    validates :work_start_time, if: :work_end_time?
    validates :work_end_time, if: :work_start_time?
  end

  # validates :admin_id, presence: true, unless: :employee_id?
  # validates :employee_id, presence: true, unless: :admin_id?
end
