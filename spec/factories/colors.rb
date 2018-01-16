FactoryGirl.define do
  factory :color do
    name { Faker::Color.color_name }
  end
end
