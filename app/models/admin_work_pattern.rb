class AdminWorkPattern < ApplicationRecord
  belongs_to :admin
  belongs_to :work_pattern

  validates :possibility, inclusion: { in: [true, false]}
end
