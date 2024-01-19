require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    # 2025年を指定されていたが、作成日を降順に設定しているため新たにタスクを作成した場合、新しいタスクが一番上に表示されるテストが実施できないため2023年に変更しています。
    let!(:first_task) { create(:task, title: 'first_task', created_at: '2023-02-18') }
    let!(:second_task) { create(:task, title: 'second_task', created_at: '2023-02-17') }
    let!(:third_task) { create(:task, title: 'third_task', created_at: '2023-02-16') }

    before do
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'first_task'
        expect(task_list[1]).to have_content 'second_task'
        expect(task_list[2]).to have_content 'third_task'
      end
    end

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        visit new_task_path
        fill_in 'task_title', with: 'new_task'
        fill_in 'task_content', with: 'new_content'
        click_button 'create-task'
        visit tasks_path
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'new_task'
      end
    end
  end
end