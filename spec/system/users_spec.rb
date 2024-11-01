RSpec.describe Users, type: :system do
  describe '新規登録' do
    before do
      visit new_user_registration_path
    end

    context 'フォームの入力値が正常' do
      it '登録成功' do
        fill_in 'user_name', with: 'Bob'
        fill_in 'user_email', with: 'bob@example.com'
        fill_in 'user_password', with: 'Abcd1234'
        fill_in 'user_password_confirmation', with: 'Abcd1234'
        within '.actions' do
          click_button '新規登録'
        end

        expect(page).to have_content 'アカウント登録が完了しました。'
      end
    end

    context 'フォームの入力値が異常' do
      it '登録失敗' do
        fill_in 'user_name', with: ''
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: ''
        fill_in 'user_password_confirmation', with: ''
        within '.actions' do
          click_button '新規登録'
        end

        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content 'パスワードを入力してください'
        expect(page).to have_content '氏名を入力してください'
      end
    end
  end
end
