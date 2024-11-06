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
    it '購入確認画面' do
      visit cart_path
      click_on '購入画面'

      expect(page).to have_css 'h1', text: '購入確認'
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
  end
end
