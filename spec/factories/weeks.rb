FactoryGirl.define do
  factory :week do
    initial_day { Faker::Date }
    week { rand(1..51) }
  end

  trait :first_week_2018 do
    initial_day { Date.parse("2018-01-01") }
    week {1}
  end

  trait :second_week_2018 do
    initial_day { Date.parse("2018-01-08") }
    week {2}
  end

  trait :week_24_2018 do
    initial_day { Date.parse("2018-06-13") }
    week {24}
  end

end
