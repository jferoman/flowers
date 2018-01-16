FactoryGirl.define do
  factory :bed_type do
    name { %w(Ancha angosta).sample }
    width { [50,54].sample }
    block
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
