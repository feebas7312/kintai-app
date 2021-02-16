class EmployeeWorkPattern < ApplicationRecord
  belongs_to :employee
  belongs_to :work_pattern

  with_options presence: true do
    validates :employee_id
    validates :work_pattern_id
    validates :possibility, inclusion: { in: [true, false]}
  end
end
