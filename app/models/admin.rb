class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def email_required?
    false
  end
  
  def email_changed?
    false
  end

  has_one :company, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :admin_work_patterns, dependent: :destroy
  has_many :work_schedules, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :employment_status
  belongs_to :salary_system

  with_options presence: true do
    validates :number
    validates :last_name
    validates :first_name
    validates :birth_date
    validates :joining_date
  end

  validates :phone_number, format: { with: /\A\d{10}$|^\d{11}\z/, message: 'を数字のみで入力してください' }, allow_blank: true
  validates :employment_status_id, numericality: { message: 'を選択してください' }
  validates :salary_system_id, numericality: { message: 'を選択してください' }
end
