FactoryGirl.define do
  factory :variety do
    participation { rand (0.0..1.0)}
    name { Faker::GameOfThrones.house }
  end

  trait :with_color_flower do
      color
      flower
      storage_resistance_type
  end
end
