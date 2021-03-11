class EmploymentStatus < ActiveHash::Base
  self.data = [
    { id: 1, name: '正社員' },
    { id: 2, name: '契約社員/嘱託社員' },
    { id: 3, name: 'パートタイマー' },
    { id: 4, name: 'アルバイト' },
    { id: 5, name: '派遣社員' },
    { id: 6, name: '未分類' }
  ]

  include ActiveHash::Associations
  has_many :admins
  has_many :employees
end