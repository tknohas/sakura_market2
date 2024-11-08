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
      expect(texts).to eq %W(#{user.id} Alice alice@example.com 2024年11月08日)
    end
  end
end
