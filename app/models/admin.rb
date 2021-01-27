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

  has_one :company

  with_options presence: true do
    validates :number
    validates :last_name
    validates :first_name
  end

  validates :number, uniqueness: true
end
