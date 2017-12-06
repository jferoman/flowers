FactoryGirl.define do
  factory :bed_type do
    name { %w(Ancha Angosta).sample }
    width { [64,50].sample }
  end
end
