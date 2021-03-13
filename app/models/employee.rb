class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :current_password

  def email_required?
    false
  end

  def email_changed?
    false
  end

  belongs_to :admin
  has_many :employee_work_patterns, dependent: :destroy

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

  validates :number, uniqueness: { scope: :admin_id }
  validates :phone_number, format: { with: /\A\d{10}$|^\d{11}\z/, message: 'Input only number' }, if: :phone_number?
  validates :employment_status_id, numericality: { message: 'Select' }
  validates :salary_system_id, numericality: { message: 'Select' }
end
