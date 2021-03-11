class SalarySystem < ActiveHash::Base
  self.data = [
    { id: 1, name: '月給制' },
    { id: 2, name: '時給制' },
    { id: 3, name: '日給制' },
    { id: 4, name: '週給制' },
    { id: 5, name: '未分類' }
  ]

  include ActiveHash::Associations
  has_many :admins
  has_many :employees
end