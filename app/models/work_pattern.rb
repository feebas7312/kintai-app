class WorkPattern < ApplicationRecord
  belongs_to :company
  has_many :admin_work_patterns, dependent: :destroy
  has_many :employee_work_patterns, dependent: :destroy

  with_options presence: true do
    validates :start_time, format: { with: /\A\d{4}\z/, message: 'を半角数字4桁で入力してください' }
    validates :end_time, format: { with: /\A\d{4}\z/, message: 'を半角数字4桁で入力してください' }
    validates :company_id
  end
end
