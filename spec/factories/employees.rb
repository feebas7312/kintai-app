FactoryBot.define do
  factory :employee do
    number                { Faker::Number.number(digits: 7) }
    last_name             { "aaa" }
    first_name            { "aaa" }
    birth_date            { "1987-11-11" }
    phone_number          { "09012345678" }
    email                 { Faker::Internet.free_email }
    password              { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    joining_date          { "2015-04-01" }
    employment_status_id  { 2 }
    salary_system_id      { 2 }
    wages                 { }
    association :admin
  end
end
