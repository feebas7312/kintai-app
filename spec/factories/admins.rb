FactoryBot.define do
  factory :admin do
    number                { "351550" }
    last_name             { "aaa" }
    first_name            { "aaa" }
    birth_date            { "1987-03-12" }
    phone_number          { "09012345678" }
    email                 { Faker::Internet.free_email }
    password              { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    joining_date          { "2015-04-01" }
    employment_status_id  { 1 }
    salary_system_id      { 1 }
    wages                 { "1000" }
  end
end
