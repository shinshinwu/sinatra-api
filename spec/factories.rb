require 'factory_girl'
require 'faker'
FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    name { Faker::Name.name }
    bio { Faker::Lorem.paragraph }
  end

  factory :article do
    title { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
    user
  end

  factory :comment do
    body { Faker::Lorem.paragraph }
    user
    article
  end
end
