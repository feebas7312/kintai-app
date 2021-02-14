class Company < ApplicationRecord
  belongs_to :admin, optional: true
  has_many :work_patterns

  with_options presence: true do
    validates :name
    validates :opening_time
    validates :closing_time
  end
end
