require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    # 2025年を指定されていたが、作成日を降順に設定しているため新たにタスクを作成した場合、新しいタスクが一番上に表示されるテストが実施できないため2023年に変更しています。
    let!(:first_task) { create(:task, title: 'first_task', created_at: '2023-02-18', deadline_on: "2025-02-18", priority: "中", status: "未着手") }
    let!(:second_task) { create(:task, title: 'second_task', created_at: '2023-02-17', deadline_on: "2025-02-17", priority: "高", status: "着手中") }
    let!(:third_task) { create(:task, title: 'third_task', created_at: '2023-02-16', deadline_on: "2025-02-16", priority: "低", status: "完了") }

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
        select '高', from: 'task_priority'
        select '未着手', from: 'task_status'
        click_button 'create-task'
        visit tasks_path
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'new_task'
      end
    end

    describe 'ソート機能' do
      context '「終了期限」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          click_link '終了期限'
          task_list = all('tbody tr')
          expect(task_list[0]).to have_content 'third_task'
          expect(task_list[1]).to have_content 'second_task'
          expect(task_list[2]).to have_content 'first_task'
        end
      end

      context '「優先度」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          click_link '優先度'
          task_list = all('tbody tr')
          expect(task_list[0]).to have_content 'second_task'
          expect(task_list[1]).to have_content 'first_task'
          expect(task_list[2]).to have_content 'third_task'
        end
      end
    end

    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it "検索ワードを含むタスクのみ表示される" do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          fill_in 'タイトル', with: 'first'
          click_button '検索'
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end
      context 'ステータスで検索した場合' do
        it "検索したステータスに一致するタスクのみ表示される" do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          select '未着手', from: 'ステータス'
          click_button '検索'
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end
      context 'タイトルとステータスで検索した場合' do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          fill_in 'タイトル', with: 'first'
          select '未着手', from: 'ステータス'
          click_button '検索'
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end
    end
  end
end