Admin.create(
  number: "351550",
  last_name: "萩野",
  first_name: "恵美菜",
  joining_date: "2015-04-01",
  password: "password",
  password_confirmation: "password"
)

Company.create(
  name: 'ルッソ',
  opening_time: '09:00:00',
  closing_time: '22:00:00',
  admin_id: 1
)

5.times do |i|
  Employee.create(
    [
      {
        number: "F35155#{i+1}",
        last_name: "スタッフ#{i+1}",
        first_name: "test",
        joining_date: "2020-09-20",
        password: "password",
        password_confirmation: "password",
        admin_id: 1
      }
    ]
  )
end