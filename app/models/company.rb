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

  validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'を正しく入力してください' }, if: :postal_code?
  validates :phone_number, format: { with: /\A\d{10}$|^\d{11}\z/, message: 'を数字のみで入力してください' }, if: :phone_number?
  validates :cutoff_date_id, numericality: { message: 'を選択してください' }
end
