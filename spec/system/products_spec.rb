RSpec.describe 'Products', type: :system do
  let!(:product) { create(:product, name: 'にんじん', price: 1_000, description: '商品説明です。') }

  describe '商品一覧' do
    it '商品情報が表示される' do
      visit root_path

      expect(page).to have_css 'h1', text: '商品一覧'
      expect(page).to have_content 'にんじん'
      expect(page).to have_content '1,000円'
    end
  end
end
