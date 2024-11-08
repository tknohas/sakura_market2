RSpec.describe 'Users', type: :system do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user, name: 'Alice', email: 'alice@example.com', password: '123456') }

  before do
    admin_login(admin)
  end

  describe 'ユーザー一覧' do
    it 'ユーザー情報が表示される' do
      visit admin_users_path

      expect(page).to have_css 'h1', text: 'ユーザー一覧'
      texts = all('tbody tr td').map(&:text)
      expect(texts).to eq %W(Alice alice@example.com #{user.created_at.strftime('%Y年%m月%d日')})
    end
  end
end
