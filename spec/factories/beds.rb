FactoryGirl.define do
  factory :bed do
    number {rand(5000)}
    total_area { rand (500.0) }
    usable_area { rand (499.0) }
    association :bed_type, factory: :bed_type
  end


end
