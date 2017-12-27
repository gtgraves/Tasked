FactoryBot.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    username Faker::Name.first_name
    password Faker::Name.last_name
  end
end
