require 'rails_helper'

RSpec.describe 'ラベル管理機能', type: :system do
  let(:user) { FactoryBot.create(:user, email: "test@example.com", password: "password") }

  describe '登録機能' do
    before do
      visit new_session_path
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      click_button 'ログイン'
    end
    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        visit new_label_path
        fill_in '名前', with: '新しいラベル'
        click_button '登録する'
        expect(page).to have_content '新しいラベル'
      end
    end
  end

  describe '一覧表示機能' do
    before do
      FactoryBot.create(:label, name: 'テストラベル1', user: user)
      visit new_session_path
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      click_button 'ログイン'
    end
    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        visit labels_path
        expect(page).to have_content 'テストラベル1'
      end
    end
  end
end