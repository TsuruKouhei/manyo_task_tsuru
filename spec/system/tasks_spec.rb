require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:user) { User.create(name: 'user_name', email: 'user@email.com', password: 'password') }
  let!(:admin) { User.create(name: 'admin_name', email: 'admin@email.com', password: 'password', admin: true) }
  let!(:task_created_by_user){Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)}
  let!(:task_created_by_admin){Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: admin.id)}
  let!(:label_created_by_user) { Label.create(name: 'label_name', user_id: user.id)}
  let!(:label_created_by_admin) { Label.create(name: 'label_name', user_id: admin.id)}

  describe '6.タスク編集画面では、タスクに紐づいているラベルにチェックが入った状態で表示させること' do
    before do
      visit new_session_path
      sleep 0.5
      find('input[name="session[email]"]').set(user.email)
      find('input[name="session[password]"]').set(user.password)
      click_button 'ログイン'
      sleep 0.5
    end
    it 'タスク編集画面では、タスクに紐づいているラベルにチェックが入った状態で表示させること' do
      10.times { |t| Label.create!(id: t+1, name: "label_#{t+1}", user_id: user.id) }
      task_created_by_user.labels << Label.find(2,7,9)
          visit edit_task_path(task_created_by_user)
          sleep 0.5
          expect(page).to have_checked_field('label_2')
          expect(page).to have_checked_field('label_7')
          expect(page).to have_checked_field('label_9')
          expect(page).to have_unchecked_field('label_1')
          expect(page).to have_unchecked_field('label_3')
          expect(page).to have_unchecked_field('label_4')
          expect(page).to have_unchecked_field('label_5')
          expect(page).to have_unchecked_field('label_6')
          expect(page).to have_unchecked_field('label_8')
          expect(page).to have_unchecked_field('label_10')
      end
    end
  # describe '一覧表示機能' do
  #   # 2025年を指定されていたが、作成日を降順に設定しているため新たにタスクを作成した場合、新しいタスクが一番上に表示されるテストが実施できないため2023年に変更しています。
  #   let!(:first_task) { create(:task, user: user, title: 'first_task', created_at: '2023-02-18', deadline_on: "2025-02-18", priority: "中", status: "未着手") }
  #   let!(:second_task) { create(:task, user: user, title: 'second_task', created_at: '2023-02-17', deadline_on: "2025-02-17", priority: "高", status: "着手中") }
  #   let!(:third_task) { create(:task, user: user, title: 'third_task', created_at: '2023-02-16', deadline_on: "2025-02-16", priority: "低", status: "完了") }
  #   let!(:user) { FactoryBot.create(:user) }

  #   before do
  #     # ログインさせるコードを記述
  #     visit new_session_path
  #     fill_in 'メールアドレス', with: user.email
  #     fill_in 'パスワード', with: user.password
  #     click_button 'ログイン'
  #   end

  #   context '一覧画面に遷移した場合' do
  #     it '作成済みのタスク一覧が作成日時の降順で表示される' do
  #       task_list = all('tbody tr')
  #       expect(task_list[0]).to have_content 'first_task'
  #       expect(task_list[1]).to have_content 'second_task'
  #       expect(task_list[2]).to have_content 'third_task'
  #     end
  #   end

  #   context '新たにタスクを作成した場合' do
  #     it '新しいタスクが一番上に表示される' do
  #       visit new_task_path
  #       fill_in 'task_title', with: 'new_task'
  #       fill_in 'task_content', with: 'new_content'
  #       select '高', from: 'task_priority'
  #       select '未着手', from: 'task_status'
  #       click_button 'create-task'
  #       visit tasks_path
  #       task_list = all('tbody tr')
  #       expect(task_list[0]).to have_content 'new_task'
  #     end
  #   end

  #   describe 'ソート機能' do
  #     context '「終了期限」というリンクをクリックした場合' do
  #       it "終了期限昇順に並び替えられたタスク一覧が表示される" do
  #         # allメソッドを使って複数のテストデータの並び順を確認する
  #         click_link '終了期限'
  #         task_list = all('tbody tr')
  #         expect(task_list[0]).to have_content 'third_task'
  #         expect(task_list[1]).to have_content 'second_task'
  #         expect(task_list[2]).to have_content 'first_task'
  #       end
  #     end

  #     context '「優先度」というリンクをクリックした場合' do
  #       it "優先度の高い順に並び替えられたタスク一覧が表示される" do
  #         # allメソッドを使って複数のテストデータの並び順を確認する
  #         click_link '優先度'
  #         task_list = all('tbody tr')
  #         expect(task_list[0]).to have_content 'second_task'
  #         expect(task_list[1]).to have_content 'first_task'
  #         expect(task_list[2]).to have_content 'third_task'
  #       end
  #     end
  #   end

  #   describe '検索機能' do
  #     context 'タイトルであいまい検索をした場合' do
  #       it "検索ワードを含むタスクのみ表示される" do
  #         # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
  #         fill_in 'タイトル', with: 'first'
  #         click_button '検索'
  #         expect(page).to have_content 'first_task'
  #         expect(page).not_to have_content 'second_task'
  #         expect(page).not_to have_content 'third_task'
  #       end
  #     end
  #     context 'ステータスで検索した場合' do
  #       it "検索したステータスに一致するタスクのみ表示される" do
  #         # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
  #         select '未着手', from: 'ステータス'
  #         click_button '検索'
  #         expect(page).to have_content 'first_task'
  #         expect(page).not_to have_content 'second_task'
  #         expect(page).not_to have_content 'third_task'
  #       end
  #     end
  #     context 'タイトルとステータスで検索した場合' do
  #       it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
  #         # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
  #         fill_in 'タイトル', with: 'first'
  #         select '未着手', from: 'ステータス'
  #         click_button '検索'
  #         expect(page).to have_content 'first_task'
  #         expect(page).not_to have_content 'second_task'
  #         expect(page).not_to have_content 'third_task'
  #       end
  #     end
  #   end
  # end
end