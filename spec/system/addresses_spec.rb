RSpec.describe 'Addresses', type: :system do
  let(:user) { create(:user, name: 'Alice', email: 'alice@example.com', password: '123456') }

  before do
    user_login(user)
  end

  describe '住所登録' do
    context 'フォームの入力値が正常' do
      it '登録成功' do
        visit new_address_path

        fill_in 'address_zip_code', with: '145-0071'
        fill_in 'address_prefecture', with: '東京都'
        fill_in 'address_city', with: '大田区'
        fill_in 'address_street', with: '田園調布2-62'
        fill_in 'address_building', with: '田園調布駅'
        within '.actions' do
          click_button '登録する'
        end

        expect(page).to have_content '登録しました'
        expect(page).to have_css 'h1', text: '購入確認'
      end
    end

    context 'フォームの入力値が異常' do
      it '登録失敗' do
        visit new_address_path

        fill_in 'address_zip_code', with: ''
        fill_in 'address_prefecture', with: ''
        fill_in 'address_city', with: ''
        fill_in 'address_street', with: ''
        fill_in 'address_building', with: ''
        within '.actions' do
          click_button '登録する'
        end

        expect(page).to have_content '登録に失敗しました'
        expect(page).to have_css 'h1', text: '住所登録'
      end
    end
  end

  describe '住所編集' do
    let!(:address) { create(:address, user:, zip_code: '145-0071', prefecture: '東京都', city: '大田区', street: '田園調布2-62') }
    let!(:cart) { create(:cart, user:) }
    let!(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, product:, cart:) }

    context 'フォームの入力値が正常' do
      it '編集成功' do
        visit edit_address_path

        fill_in 'address_zip_code', with: '152-0035'
        fill_in 'address_prefecture', with: '東京都'
        fill_in 'address_city', with: '目黒区'
        fill_in 'address_street', with: '自由が丘1-9-8'
        fill_in 'address_building', with: '自由が丘駅'
        within '.actions' do
          click_button '変更する'
        end

        expect(page).to have_content '変更しました'
        expect(page).to have_css 'h1', text: '購入確認'
        expect(page).to have_content '152-0035'
        expect(page).to have_content '東京都'
        expect(page).to have_content '目黒区'
        expect(page).to have_content '自由が丘1-9-8'
        expect(page).to have_content '自由が丘駅'
      end
    end

    context 'フォームの入力値が異常' do
      it '編集失敗' do
        visit edit_address_path

        fill_in 'address_zip_code', with: ''
        fill_in 'address_prefecture', with: ''
        fill_in 'address_city', with: ''
        fill_in 'address_street', with: ''
        fill_in 'address_building', with: ''
        within '.actions' do
          click_button '変更する'
        end

        expect(page).to have_content '変更に失敗しました'
        expect(page).to have_css 'h1', text: '住所編集'
      end
    end
  end
end
