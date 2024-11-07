RSpec.describe 'Purchases', type: :system do
  let(:user) { create(:user, name: 'Alice', email: 'alice@example.com', password: '123456') }
  let!(:product) { create(:product, name: 'にんじん', price: 1_000) }
  let!(:product1) { create(:product, name: 'ピーマン', price: 2_000) }
  let!(:product2) { create(:product, name: '玉ねぎ', price: 3_000) }
  let!(:cart) { create(:cart, user:) }
  let!(:cart_item) { create(:cart_item, cart:, product:, amount: 3) }
  let!(:cart_item1) { create(:cart_item, cart:, product: product1, amount: 1) }
  let!(:cart_item2) { create(:cart_item, cart:, product: product2, amount: 5) }

  before do
    user_login(user)
  end

  describe '購入' do
    context '住所が登録されている場合' do
      let!(:address) { create(:address, user:, zip_code: '145-0071', prefecture: '東京都', city: '大田区', street: '田園調布2-62') }

      it '商品を購入できる' do
        visit cart_path
        click_on '購入画面'

        expect(page).to have_css 'h1', text: '購入確認'
        expect(page).to have_content '145-0071'
        expect(page).to have_content '東京都'
        expect(page).to have_content '大田区'
        expect(page).to have_content '田園調布2-62'

        fill_in 'purchase_delivery_date', with: 3.business_days.after(Date.current)
        find("#purchase_delivery_time").find("option[value='14:00~16:00']").select_option
        click_on '購入確定'

        expect(page).to have_current_path root_path
        expect(page).to have_content '購入が完了しました'
        expect(Purchase.last).to be_present
        expect(cart.cart_items).to_not be_present
        expect(Purchase.last.subtotal).to eq 20000
        expect(Purchase.last.shipping_fee).to eq 1200
        expect(Purchase.last.delivery_fee).to eq 400
        expect(Purchase.last.tax).to eq 2160
        expect(Purchase.last.total_price).to eq 23760
        expect(PurchaseItem.first.amount).to eq 3
        expect(PurchaseItem.second.amount).to eq 1
        expect(PurchaseItem.third.amount).to eq 5
        expect(Purchase.last.delivery_date).to eq 3.business_days.after(Date.current)
        expect(Purchase.last.delivery_time).to eq '14:00~16:00'
      end

      it '住所編集画面へ遷移する' do
        visit new_purchase_path

        click_on '住所を編集'
        expect(page).to have_css 'h1', text: '住所編集'
      end
    end

    context '住所が登録されていない場合' do
      it '住所登録画面へのリンクが表示される' do
        visit new_purchase_path

        expect(page).to_not have_button '購入確定'
        click_on '住所を登録'

        expect(page).to have_css 'h1', text: '住所登録'
      end
    end
  end
end
