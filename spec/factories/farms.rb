FactoryGirl.define do
  factory :farm do
    code "MyString"
    name Faker::DragonBall.character
    mamsl 1.5
    pluviosity 1.5
  end

  trait :with_company do
    company
  end

end
