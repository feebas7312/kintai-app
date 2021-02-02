class WorkSchedule < ApplicationRecord
  belongs_to :admin
  belongs_to :employee

  with_options presence: true do
    validates :work_date
    validates :work_start_time
    validates :work_end_time
  end

  validates :admin, presence: true, unless: :employee?
  validates :employee, presence: true, unless: :admin?
end
