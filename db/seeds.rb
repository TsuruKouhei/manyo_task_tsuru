# 一般ユーザーの作成
user = User.create!(
  name: '一般ユーザー',
  email: 'user-seed@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: false
)

# 管理者ユーザーの作成
admin = User.create!(
  name: '管理者ユーザー',
  email: 'admin-seed@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

# 一般ユーザーに関連付けられたタスクの作成
50.times do |n|
  user.tasks.create!(
    title: "一般ユーザーのタスク#{n + 1}",
    content: "一般ユーザーのタスク内容#{n + 1}",
    deadline_on: Time.current + n.days,
    priority: ['低', '中', '高'].sample,
    status: ['未着手', '着手中', '完了'].sample
  )
end

# 管理者ユーザーに関連付けられたタスクの作成
50.times do |n|
  admin.tasks.create!(
    title: "管理者ユーザーのタスク#{n + 1}",
    content: "管理者ユーザーのタスク内容#{n + 1}",
    deadline_on: Time.current + n.days,
    priority: ['低', '中', '高'].sample,
    status: ['未着手', '着手中', '完了'].sample
  )
end