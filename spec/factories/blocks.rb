FactoryGirl.define do
  factory :block do
    name {"Bloque_uno"}
    farm

    trait :first_block do
      name "Bloque 100"
      area 100.0
    end

    trait :second_block do
      name "Bloque 200"
      area 200.0
    end

    trait :third_block do
      name "Bloque 300"
      area 300.0
    end

    trait :large_block do
      name "Bloque grande"
      area 5000.0
    end

  end
end
