FactoryGirl.define do
  factory :storage_resistance do
    week_number { rand(152)}
    lost_percentage { rand(0.0..1.0) }
  end
end
