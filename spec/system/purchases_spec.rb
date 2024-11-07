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

  describe '購入履歴' do
    let!(:purchase) { create(:purchase, user:, delivery_date: "#{3.business_days.after(Date.current)}", delivery_time: '8:00~12:00') }
    let!(:purchase_item) { create(:purchase_item, product:, purchase:) }
    let!(:purchase_item1) { create(:purchase_item, purchase:, product: product1, amount: 1) }
    let!(:purchase_item2) { create(:purchase_item, purchase:, product: product2, amount: 5) }
    let!(:address) { create(:address, user:, zip_code: '145-0071', prefecture: '東京都', city: '大田区', street: '田園調布2-62') }

    it '購入履歴が表示される' do
      click_on '購入履歴'

      expect(page).to have_css 'h1', text: '購入履歴'
      texts = all('tbody tr td').map(&:text)
      expect(texts).to eq ["#{purchase.id}", "にんじん / ピーマン / 玉ねぎ", "23,760円", "#{purchase.created_at.strftime('%Y年%m月%d日')}"]
    end

    it '購入履歴詳細画面へ遷移する' do
      click_on '購入履歴'
      click_on 'にんじん / ピーマン / 玉ねぎ'

      expect(page).to have_css 'h1', text: '購入履歴詳細'
    end

    describe '購入履歴詳細' do
      it '購入金額明細が表示される' do
        visit purchase_path(purchase)

        expect(page).to have_css 'h1', text: '購入履歴詳細'
        expect(page).to have_content '20,000円'
        expect(page).to have_content '1,200円'
        expect(page).to have_content '400円'
        expect(page).to have_content '2,160円'
        expect(page).to have_content '23,760円'
      end

      it '希望配達日時が表示される' do
        visit purchase_path(purchase)

        expect(page).to have_css 'h1', text: '購入履歴詳細'
        expect(page).to have_content '8:00~12:00'
        expect(page).to have_content "#{3.business_days.after(Date.current).strftime('%Y年%m月%d日')}"
      end

      it '配送先住所が表示される' do
        visit purchase_path(purchase)

        expect(page).to have_css 'h1', text: '購入履歴詳細'
        expect(page).to have_content '145-0071'
        expect(page).to have_content '東京都'
        expect(page).to have_content '大田区'
        expect(page).to have_content '田園調布2-62'
      end

      it '購入した商品が表示される' do
        visit purchase_path(purchase)

        expect(page).to have_css 'h1', text: '購入履歴詳細'
        texts = all('tbody tr').map(&:text)
        expect(texts).to eq ["にんじん\n1,000円\n1\n1,000円", "ピーマン\n2,000円\n1\n2,000円", "玉ねぎ\n3,000円\n5\n15,000円"]
      end

      it '商品詳細画面へ遷移する' do
        visit purchase_path(purchase)

        click_on 'にんじん'
        expect(page).to have_css 'h1', text: '商品詳細'
        expect(page).to have_content 'にんじん'
      end
    end
  end
end
