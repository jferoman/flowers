FactoryGirl.define do
  factory :company do
    name Faker::Company.name
    nit 1
    phone ""
  end
end
