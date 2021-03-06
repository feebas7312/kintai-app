class AdminWorkPattern < ApplicationRecord
  belongs_to :admin
  belongs_to :work_pattern

  with_options presence: true do
    validates :admin_id
    validates :work_pattern_id
    validates :possibility, inclusion: { in: [true, false]}
  end
end
