FactoryBot.define do
  factory :work_schedule do
    work_date  {"2021-04-20"}
    start_time {"0900"}
    end_time   {"1800"}
    break_time {60}
    work_time  {480}
    association :admin
    association :employee
  end
end
