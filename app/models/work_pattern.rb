class WorkPattern < ApplicationRecord
  belongs_to :company
  has_many :admin_work_patterns, dependent: :destroy
  has_many :employee_work_patterns, dependent: :destroy

  with_options presence: true do
    validates :start_time, format: { with: /\A\d{4}\z/, message: 'Please enter in 4 digits' }
    validates :end_time, format: { with: /\A\d{4}\z/, message: 'Please enter in 4 digits' }
    validates :company_id
  end
end
