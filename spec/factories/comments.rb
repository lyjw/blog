FactoryGirl.define do
  factory :comment do
    association :post, factory: :post
    association :user, factory: :user

    body    Faker::Hipster.sentence
  end
end
