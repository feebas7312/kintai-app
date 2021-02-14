class WorkPattern < ApplicationRecord
  belongs_to :company

  with_options presence: true do
    validates :start_time
    validates :end_time
  end
end
