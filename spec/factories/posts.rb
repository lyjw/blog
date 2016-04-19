FactoryGirl.define do
  factory :post do
     sequence(:title) { |n| Faker::Company.catch_phrase }
     body             Faker::Hipster.paragraph(2)
  end
end
