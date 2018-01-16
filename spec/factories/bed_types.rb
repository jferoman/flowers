FactoryGirl.define do
  factory :bed_type do
  end

  trait :ancha do
    name { "Ancha" }
    width { 64 }
  end

  trait :angosta do
    name { "Angosta" }
    width { 50 }
  end
end
