FactoryBot.define do
  factory :company do
    name           { "会社名" }
    postal_code    { "730-8511" }
    address        { "広島県広島市中区基町10-52" }
    phone_number   { "09012345678" }
    cutoff_date_id { 4 }
    opening_time   { "09:00:00" }
    closing_time   { "22:00:00" }
    association :admin
  end
end
