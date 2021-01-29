class Employee < ApplicationRecord
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

  belongs_to :admin

  with_options presence: true do
    validates :number
    validates :last_name
    validates :first_name
  end

  validates :number, uniqueness: true
end
