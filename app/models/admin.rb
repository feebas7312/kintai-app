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

  with_options presence: true do
    validates :employee_number
    validates :last_name
    validates :first_name
  end

  validates :employee_number, uniqueness: true
end
