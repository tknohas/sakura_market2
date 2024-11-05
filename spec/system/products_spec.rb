RSpec.describe 'Products', type: :system do
  let!(:product) { create(:product, name: 'にんじん', price: 1_000, description: '商品説明です。') }

  describe '商品一覧' do
    it '商品情報が表示される' do
      visit root_path

      expect(page).to have_css 'h1', text: '商品一覧'
      expect(page).to have_content 'にんじん'
      expect(page).to have_content '1,000円'
      expect(page).to have_css 'img.product-image'
    end

    it '商品詳細画面へ遷移する' do
      visit root_path
      click_on 'にんじん'

      expect(page).to have_css 'h1', text: '商品詳細'
    end
  end

  describe '商品詳細' do
    it '商品情報が表示される' do
      visit product_path(product)

      expect(page).to have_css 'h1', text: '商品詳細'
      expect(page).to have_content 'にんじん'
      expect(page).to have_content '1,000円'
      expect(page).to have_content '商品説明です。'
      expect(page).to have_css 'img.product-image'
    end

    it 'トップ画面へ遷移する' do
      visit product_path(product)
      click_on 'トップ'

      expect(page).to have_css 'h1', text: '商品一覧'
    end
  end
end
