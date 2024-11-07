RSpec.describe 'Products', type: :system do
  let!(:product) { create(:product, name: 'にんじん', price: 1_000, description: '商品説明です。') }
  let!(:private_product) { create(:product, name: 'ピーマン', price: 2_000, private: true) }

  describe '商品一覧' do
    context 'privateがfalseの場合' do
      it '商品情報が表示される' do
        visit root_path

        expect(page).to have_css 'h1', text: '商品一覧'
        expect(page).to have_content 'にんじん'
        expect(page).to have_content '1,000円'
        expect(page).to have_css 'img.product-image'
      end
    end

    context 'privateがtrueの場合' do
      it '商品情報が表示されない' do
        visit root_path

        expect(page).to have_css 'h1', text: '商品一覧'
        expect(page).to have_content 'にんじん'
        expect(page).to have_content '1,000円'
        expect(page).to have_css 'img.product-image'
        expect(page).to have_no_content 'ピーマン'
        expect(page).to have_no_content '2,000円'
      end
    end

    it '商品詳細画面へ遷移する' do
      visit root_path
      click_on 'にんじん'

      expect(page).to have_css 'h1', text: '商品詳細'
    end
  end

  describe '商品詳細' do
    context 'privateがfalseの場合' do
      it '商品情報が表示される' do
        visit product_path(product)

        expect(page).to have_css 'h1', text: '商品詳細'
        expect(page).to have_content 'にんじん'
        expect(page).to have_content '1,000円'
        expect(page).to have_content '商品説明です。'
        expect(page).to have_css 'img.product-image'
      end
    end

    context 'privateがtrueの場合' do
      it '商品情報が表示されない' do
        visit product_path(private_product)

        expect(page).to have_css 'h1', text: '商品詳細'
        expect(page).to have_content '現在、この商品は公開されていません。'
        expect(page).to have_no_content 'ピーマン'
        expect(page).to have_no_content '2,000円'
        expect(page).to have_no_content '商品説明です。'
        expect(page).to have_no_css 'img.product-image'
      end
    end

    it 'トップ画面へ遷移する' do
      visit product_path(product)
      click_on 'トップ'

      expect(page).to have_css 'h1', text: '商品一覧'
    end
  end
end
