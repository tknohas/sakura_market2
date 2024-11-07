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

        expect(page).to have_content '変更に失敗しました'
        expect(page).to have_css 'h1', text: '住所登録'
      end
    end
  end
end
