class Company < ApplicationRecord
  belongs_to :admin, optional: true
  has_many :work_patterns, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :cutoff_date

  with_options presence: true do
    validates :name
    validates :opening_time
    validates :closing_time
  end

  validates :cutoff_date_id, numericality: { message: 'Select' }
end
