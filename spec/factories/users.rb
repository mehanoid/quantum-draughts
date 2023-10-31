# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password { '123456' }
  end
end
