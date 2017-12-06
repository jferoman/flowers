FactoryGirl.define do
  factory :company do
    name Faker::Company.name
    nit 1
    phone '318852297'
  end
end
