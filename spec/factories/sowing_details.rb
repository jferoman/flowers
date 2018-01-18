FactoryGirl.define do
  factory :sowing_detail do
    quantity { rand(0..5000) }
    cutting_week { rand(0..51) }
    status { "Ejecutado" }
  end

  trait :specific do
    quantity { 1146 }
    cutting_week { rand(0..51) }
    status { "Ejecutado" }
  end

end
