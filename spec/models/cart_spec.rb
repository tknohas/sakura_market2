RSpec.describe Cart, type: :model do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user:) }
  let(:product1) { create(:product, price: 1000) }
  let(:product2) { create(:product, price: 2000) }

  describe '小計' do
    it '小計が計算される' do
      create(:cart_item, cart: cart, product: product1, amount: 2)
      expect(cart.subtotal).to eq(2000)
    end

    it '小計が計算される(商品が複数)' do
      create(:cart_item, cart: cart, product: product1, amount: 2)
      create(:cart_item, cart: cart, product: product2, amount: 1)
      expect(cart.subtotal).to eq(4000)
    end
  end

  describe '送料' do
    it '送料が計算される(商品数が5)' do
      create(:cart_item, cart: cart, product: product1, amount: 5)
      expect(cart.calculate_shipping_fee).to eq(600)
    end

    it '送料が計算される(商品数が6)' do
      create(:cart_item, cart: cart, product: product1, amount: 6)
      expect(cart.calculate_shipping_fee).to eq(1200)
    end

    it '送料が計算される(商品数が10)' do
      create(:cart_item, cart: cart, product: product1, amount: 10)
      expect(cart.calculate_shipping_fee).to eq(1200)
    end

    it '送料が計算される(商品数が11)' do
      create(:cart_item, cart: cart, product: product1, amount: 11)
      expect(cart.calculate_shipping_fee).to eq(1800)
    end
  end

  describe '合計金額' do
    it '小計、送料、消費税の合計が計算される' do
      create(:cart_item, cart: cart, product: product1, amount: 2)
      expected_total = ((cart.subtotal + cart.calculate_shipping_fee) * Cart::TAX_RATE).floor
      expect(cart.total_price).to eq(expected_total)
    end
  end

  describe '消費税' do
    it '消費税が計算される' do
      create(:cart_item, cart: cart, product: product1, amount: 2)
      subtotal_with_shipping = cart.subtotal + cart.calculate_shipping_fee
      expected_tax = (subtotal_with_shipping * Cart::TAX_RATE - subtotal_with_shipping).floor
      expect(cart.calculate_tax).to eq(expected_tax)
    end
  end
end
