FactoryBot.define do
  factory :user do
    name Faker::Name.name
    sequence(:email){|n| "user#{n}@factory.com" }
  end
end
