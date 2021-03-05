class CutoffDate < ActiveHash::Base
  self.data = [
    { id: 1, name: '5日' },
    { id: 2, name: '10日' },
    { id: 3, name: '15日' },
    { id: 4, name: '20日' },
    { id: 5, name: '25日' },
    { id: 6, name: '月末' }
  ]

  include ActiveHash::Associations
  has_many :companies
end