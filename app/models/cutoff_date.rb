class CutoffDate < ActiveHash::Base
  self.data = [
    { id: 1, name: '5日', next_day: 6 },
    { id: 2, name: '10日', next_day: 11 },
    { id: 3, name: '15日', next_day: 16 },
    { id: 4, name: '20日', next_day: 21 },
    { id: 5, name: '25日', next_day: 26 },
    { id: 6, name: '月末', next_day: 1 }
  ]

  include ActiveHash::Associations
  has_many :companies
end