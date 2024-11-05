RSpec.describe 'Products', type: :system do
  let(:user) { create(:user, name: 'Alice', email: 'alice@example.com', password: '123456') }
  let!(:product) { create(:product, name: 'にんじん', price: 1_000, description: '商品説明です。') }

  before do
    user_login(user)
  end

  describe 'カート' do
    it 'カートに商品を追加できる' do
      visit product_path(product)
      find("#cart_item_amount").find("option[value='5']").select_option
      click_on 'カートに追加'

      expect(page).to have_content 'カートに商品を追加しました'
      expect(page).to have_css 'h1', text: 'カート'
      texts = all('tbody tr').map(&:text)
      expect(texts).to eq ["にんじん 1,000円 5 5,000円"] #NOTE: "商品名 単価 数量 単価x数量"
    end

    it 'トップ画面へ遷移する' do
      visit cart_path
      click_on 'トップ'

      expect(page).to have_css 'h1', text: '商品一覧'
    end
  end
end
