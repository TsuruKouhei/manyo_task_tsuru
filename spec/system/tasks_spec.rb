require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        # タスクの登録処理を行う
        visit new_task_path
        fill_in 'Title', with: '新しいタスク'
        fill_in 'Content', with: '新しいタスクの詳細内容'
        click_button 'Create Task'
        # 登録後、タスク一覧画面に遷移
        visit tasks_path
        # 登録したタスクが一覧に表示されていることを確認
        expect(page).to have_content '新しいタスク'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを登録
        FactoryBot.create(:task)
        # タスク一覧画面に遷移
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        # テストで使用するためのタスクを登録
        # task = Task.create!(title: '詳細表示テスト', content: '詳細表示のテスト用タスクです。')
        second_task = FactoryBot.create(:second_task)
        # タスク詳細画面に遷移
        visit task_path(second_task.id)
        # タスク詳細画面にタイトルと内容が表示されていることを確認
        expect(page).to have_content 'メール送信'
        expect(page).to have_content '顧客へ営業のメールを送る。'

      end
    end
  end
end
