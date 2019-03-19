FactoryBot.define do
  factory :product do
  	title { "Ruby on Rails Book" }
  	description { Faker::Lorem.paragraph }
  	image_url { "rails.jpg" }
  	price { 300_000.0 }
  end
end
