require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'バリデーションのテスト' do

    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '', content: '企画書を作成する。', deadline_on: "2024-01-19", priority: "高", status: "未着手")
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '本日の仕事', content: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = user.tasks.build(title: '本日の仕事', content: '企画書を作成する', deadline_on: "2024-01-19", priority: "高", status: "未着手")
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    # テストデータを複数作成する
    let!(:first_task) { FactoryBot.create(:task, user: user, title: "first task", priority: "高", status: "未着手") }
    let!(:second_task) { FactoryBot.create(:task, user: user, title: "second task", priority: "中", status: "着手中") }
    let!(:third_task) { FactoryBot.create(:task, user: user, title: "third task", priority: "低", status: "完了") }
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        # タイトルの検索メソッドをseach_titleとしてscopeで定義した場合のコード例
        # scopeを使って定義した検索メソッドに検索ワードを挿入する
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_by_title('first')).to include(first_task)
        expect(Task.search_by_title('first')).not_to include(second_task)
        expect(Task.search_by_title('first')).not_to include(third_task)
        expect(Task.search_by_title('first').count).to eq 1
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_by_status('未着手')).to include(first_task)
        expect(Task.search_by_status('未着手')).not_to include(second_task)
        expect(Task.search_by_status('未着手')).not_to include(third_task)
        expect(Task.search_by_status('未着手').count).to eq 1
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_by_title_and_status('first', '未着手')).to include(first_task)
        expect(Task.search_by_title_and_status('first', '未着手')).not_to include(second_task)
        expect(Task.search_by_title_and_status('first', '未着手')).not_to include(third_task)
        expect(Task.search_by_title_and_status('first', '未着手').count).to eq 1
      end
    end
  end
end