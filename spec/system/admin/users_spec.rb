RSpec.describe 'Users', type: :system do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user, name: 'Alice', email: 'alice@example.com', password: '123456', created_at: '2024-11-08') }

  before do
    admin_login(admin)
  end

  describe 'ユーザー一覧' do
    it 'ユーザー情報が表示される' do
      click_on 'ユーザー管理'

      expect(page).to have_css 'h1', text: 'ユーザー一覧'
      texts = all('tbody tr td').map(&:text)
      expect(texts).to eq %W(#{user.id} Alice alice@example.com 2024年11月08日 編集)
    end

    it '編集画面へ遷移する' do
      click_on 'ユーザー管理'
      click_on '編集'

      expect(page).to have_css 'h1', text: 'ユーザー編集'
    end

    it 'トップ画面へ遷移する' do
      click_on 'ユーザー管理'
      click_on 'トップ'

      expect(page).to have_css 'h1', text: '商品一覧(管理画面)'
    end
  end

  describe 'ユーザー編集' do
    context 'フォームの入力値が正常' do
      it '編集成功' do
        visit edit_admin_user_path(user)

        fill_in 'user_name', with: 'Bob'
        fill_in 'user_email', with: 'bob@example.com'
        within '.actions' do
          click_button '変更する'
        end

        expect(page).to have_content '変更しました'
        expect(page).to have_css 'h1', text: 'ユーザー一覧'
        texts = all('tbody tr td').map(&:text)
        expect(texts).to eq %W(#{user.id} Bob bob@example.com 2024年11月08日)
      end
    end

    context 'フォームの入力値が異常' do
      it '編集失敗' do
        visit edit_admin_user_path(user)

        fill_in 'user_name', with: ''
        fill_in 'user_email', with: ''
        within '.actions' do
          click_button '変更する'
        end

        expect(page).to have_css 'h1', text: 'ユーザー編集'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content '氏名を入力してください'
      end
    end

    it 'トップ画面へ遷移する' do
      visit edit_admin_user_path(user)
      click_on 'トップ'

      expect(page).to have_css 'h1', text: '商品一覧(管理画面)'
    end

    it 'ユーザー一覧画面へ遷移する' do
      visit edit_admin_user_path(user)
      click_on '戻る'

      expect(page).to have_css 'h1', text: 'ユーザー一覧'
    end
  end
end
