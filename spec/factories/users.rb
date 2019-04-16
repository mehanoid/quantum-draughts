FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password { '123456' }
    displaying_name { 'John' }
  end
end