FactoryGirl.define do
  factory :week do
    initial_day { Faker::Date }
    week { rand(1..51)}
  end

  trait :first_week_2018 do
    initial_day {"2018-01-01"}
    week {1}
  end

end
