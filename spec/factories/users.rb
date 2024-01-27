FactoryBot.define do
  factory :user do
    name { "MyString" }
    password { "password" }
    sequence(:email) { |n| "user#{n}@example.com" }
    admin { false }
  end

  factory :admin_user, class: User do
    name { "管理ユーザー" }
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { "password" }
    admin { true }
  end
end
