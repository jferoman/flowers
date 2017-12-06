FactoryGirl.define do
  factory :storage_resistance_type do
    name { %w(Weak Medium Strong).sample }
  end
end
