FactoryBot.define do

  factory :task do
    association :user
    sequence(:title) { |n| "task_#{n}" }
    content { "Task description" }
    created_at { Time.current }
    # 他に必要な属性があればここに追加します
  end

  factory :first_task, class: Task do
    association :user
    title { 'first_task' }
    content { 'Task content for first task' }
    deadline_on { '2025-02-18' }
    priority { '中' }
    status { '未着手' }
  end


  factory :second_task, class: Task do
    association :user
    title { 'second_task' }
    content { 'Task content for second task' }
    deadline_on { '2025-02-17' }
    priority { '高' }
    status { '着手中' }
  end

  factory :third_task, class: Task do
    association :user
    title { 'third_task' }
    content { 'Task content for third task' }
    deadline_on { '2025-02-16' }
    priority { '低' }
    status { '完了' }
  end
end
