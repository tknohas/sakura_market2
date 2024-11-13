RSpec.describe 'Admins', type: :system do
  describe 'ログイン' do
    let(:admin) { create(:admin) }

    before do
      visit new_admin_session_path
    end

    context 'フォームの入力値が正常' do
      it 'ログイン成功' do
        fill_in 'admin_email', with: admin.email
        fill_in 'admin_password', with: admin.password
        within '.actions' do
          click_button 'ログイン'
        end

        expect(page).to have_content 'ログインしました。'
        expect(page).to have_css 'h1', text: '商品一覧(管理画面)'
      end
    end

    context 'フォームの入力値が異常' do
      it 'ログイン失敗' do
        fill_in 'admin_email', with: ''
        fill_in 'admin_password', with: ''
        within '.actions' do
          click_button 'ログイン'
        end

        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end
end
