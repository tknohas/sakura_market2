RSpec.describe 'Products', type: :system do
  let(:user) { create(:user, name: 'Alice', email: 'alice@example.com', password: '123456') }
  let!(:product) { create(:product, name: 'にんじん', price: 1_000, description: '商品説明です。') }
  let!(:cart) { create(:cart, user:) }

  describe 'カート(ログイン後)' do
    before do
      user_login(user)
    end

    it 'カートに商品を追加できる' do
      visit product_path(product)
      find("#cart_item_amount").find("option[value='5']").select_option
      click_on 'カートに追加'

      expect(page).to have_content 'カートに商品を追加しました'
      expect(page).to have_css 'h1', text: '商品一覧'

      click_on 'カート'
      expect(page).to have_css 'img.product-image'
      texts = all('tbody tr').map(&:text)
      expect(texts).to eq ["にんじん 1,000円 5 5,000円\n削除"] #NOTE: "商品名 単価 数量 単価x数量"
      expect(page).to have_content '5,000円' # 小計
      expect(page).to have_content '600円'   # 送料
      expect(page).to have_content '300円'   # 代引き手数料
      expect(page).to have_content '590円'   # 消費税
      expect(page).to have_content '6,490円' # 合計金額
    end

    it 'トップ画面へ遷移する' do
      visit cart_path
      click_on 'トップ'

      expect(page).to have_css 'h1', text: '商品一覧'
    end

    it 'カートから商品を削除できる', :js do
      click_on 'にんじん'
      click_on 'カートに追加'

      visit cart_path
      click_on '削除'

      expect {
        expect(page.accept_confirm).to eq '本当に削除しますか？'
        expect(page).to have_content '商品を削除しました'
      }.to change(CartItem, :count).by(-1)
    end
  end

  describe 'カート(セッション)' do
    it 'カートに商品を追加できる' do
      visit product_path(product)
      find("#cart_item_amount").find("option[value='5']").select_option
      click_on 'カートに追加'

      expect(page).to have_content 'カートに商品を追加しました'
      expect(page).to have_css 'h1', text: '商品一覧'

      click_on 'カート'
      expect(page).to have_css 'img.product-image'
      texts = all('tbody tr').map(&:text)
      expect(texts).to eq ["にんじん 1,000円 5 5,000円\n削除"] #NOTE: "商品名 単価 数量 単価x数量"
      expect(page).to have_content '5,000円' # 小計
      expect(page).to have_content '600円'   # 送料
      expect(page).to have_content '300円'   # 代引き手数料
      expect(page).to have_content '590円'   # 消費税
      expect(page).to have_content '6,490円' # 合計金額
    end

    it 'トップ画面へ遷移する' do
      visit cart_path
      click_on 'トップ'

      expect(page).to have_css 'h1', text: '商品一覧'
    end

    it 'カートから商品を削除できる', :js do
      visit product_path(product)
      click_on 'カートに追加'
      expect(page).to have_content 'カートに商品を追加しました'

      visit cart_path
      click_on '削除'

      expect {
        expect(page.accept_confirm).to eq '本当に削除しますか？'
        expect(page).to have_content '商品を削除しました'
      }.to change(CartItem, :count).by(-1)
    end
  end
end
