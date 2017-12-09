FactoryBot.define do
  factory :user do
    name Faker::Name.name
    sequence(:email){|n| "user#{n}@factory.com" }
    username Faker::Name.first_name
    password Faker::Name.last_name
  end
end
