FactoryGirl.define do
  factory :sowing_detail do
    quantity { rand(0..5000) }
    cutting_week { rand(0..51) }
    status { "Ejecutado" }
    expiration_week { 52 }
  end

  # trait :with_variety_and_week do
  #   variety
  #   week
  #   bed
  # end

end
