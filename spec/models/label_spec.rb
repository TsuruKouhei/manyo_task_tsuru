require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'バリデーションのテスト' do
    context 'ラベルの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        label = Label.new(name: '')
        expect(label).not_to be_valid
        expect(label.errors[:name]).to include("を入力してください")
      end
    end

    context 'ラベルの名前に値があった場合' do
      it 'バリデーションに成功する' do
        user = FactoryBot.create(:user) # ユーザーのファクトリを使用
        label = Label.new(name: 'テストラベル', user: user)
        expect(label).to be_valid
      end
    end
  end
end
