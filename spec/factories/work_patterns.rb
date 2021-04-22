FactoryBot.define do
  factory :work_pattern do
    start_time { "0900" }
    end_time   { "1800" }
    break_time { 60 }
    work_time  { 480 }
    association :company
  end
end
