class WorkPattern < ApplicationRecord
  belongs_to :company
  has_many :admin_work_patterns, dependent: :destroy
  has_many :employee_work_patterns, dependent: :destroy

  with_options presence: true do
    validates :start_time
    validates :end_time
    validates :company_id
  end
end
