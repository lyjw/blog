FactoryGirl.define do
  factory :post do
     association :user, factory: :user

     sequence(:title) { |n| Faker::Company.catch_phrase }
     body             Faker::Hipster.paragraph(2)
  end
end
