class Company < ApplicationRecord
  belongs_to :admin, optional: true

  with_options presence: true do
    validates :name
    validates :opening_time
    validates :closing_time
  end
end
