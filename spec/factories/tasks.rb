FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "task_#{n}" }
    content { "Task description" }
    created_at { Time.current }
    # 他に必要な属性があればここに追加します
  end
end