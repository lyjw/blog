FactoryGirl.define do
  factory :category do
    title   Faker::Color.color_name
  end
end
