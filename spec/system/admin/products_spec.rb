RSpec.describe 'Products', type: :system do
  let(:admin) { create(:admin, email: 'admin@example.com', password: '123456') }

  before do
    admin_login(admin)
  end

  describe '商品登録' do
    context 'フォームの入力値が正常' do
      it '登録成功' do
        visit new_admin_product_path

        fill_in 'product_name', with: '豆腐'
        fill_in 'product_price', with: 1_000
        fill_in 'product_description', with: 'なめらかです。'
        attach_file 'product_image', file_fixture('test_image.jpg')
        fill_in 'product_position', with: 1
        within '.actions' do
          click_button '登録する'
        end

        expect(page).to have_content '登録しました'
        expect(page).to have_css 'h1', text: '商品一覧' # TODO: 遷移先変更予定
        expect(page).to have_content '豆腐'
        expect(page).to have_css 'img.product-image'
        expect(Product.last.private).to eq false
        expect(Product.last.position).to eq 1
      end
    end

    context 'フォームの入力値が異常' do
      it '登録失敗' do
        visit new_admin_product_path

        fill_in 'product_name', with: ''
        fill_in 'product_price', with: ''
        fill_in 'product_description', with: ''
        fill_in 'product_position', with: ''
        within '.actions' do
          click_button '登録する'
        end

        expect(page).to have_content '登録に失敗しました'
        expect(page).to have_css 'h1', text: '商品登録'
      end
    end
  end
end
