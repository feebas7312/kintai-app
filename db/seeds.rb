Admin.create(
  number: "351550",
  last_name: "責任者",
  first_name: "test",
  joining_date: "2015-04-01",
  password: "password",
  password_confirmation: "password"
)

Company.create(
  name: 'テスト会社',
  postal_code: '730-8511',
  address: '広島県広島市中区基町10-52',
  phone_number: '082-228-2111',
  cutoff_date_id: 4,
  opening_time: '09:00:00',
  closing_time: '22:00:00',
  admin_id: 1
)

4.times do |i|
  Employee.create(
    [
      {
        number: "F35155#{i+1}",
        last_name: "スタッフ",
        first_name: "#{i+1}",
        joining_date: "2020-09-20",
        password: "password",
        password_confirmation: "password",
        admin_id: 1
      }
    ]
  )
end

WorkPattern.create(
  [
    { start_time: '0900', end_time: '1800', company_id: 1 },
    { start_time: '1100', end_time: '2000', company_id: 1 },
    { start_time: '1300', end_time: '2200', company_id: 1 }
  ]
)