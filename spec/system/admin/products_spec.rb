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
        expect(page).to have_css 'h1', text: '商品一覧(管理画面)'
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

  describe '商品編集' do
    let!(:product) { create(:product, name: 'にんじん', price: 1_000, description: '商品説明です。') }

    context 'フォームの入力値が正常' do
      it '編集成功' do
        visit edit_admin_product_path(product)

        fill_in 'product_name', with: '豆腐'
        fill_in 'product_price', with: 1_000
        fill_in 'product_description', with: 'なめらかです。'
        attach_file 'product_image', file_fixture('test_image.jpg')
        fill_in 'product_position', with: 2
        within '.actions' do
          click_button '変更する'
        end

        expect(page).to have_content '変更しました'
        expect(page).to have_css 'h1', text: '商品一覧(管理画面)'
        expect(page).to have_content '豆腐'
        expect(page).to have_css 'img.product-image'
        expect(Product.last.private).to eq false
        expect(Product.last.position).to eq 2
      end
    end

    context 'フォームの入力値が異常' do
      it '編集失敗' do
        visit edit_admin_product_path(product)

        fill_in 'product_name', with: ''
        fill_in 'product_price', with: ''
        fill_in 'product_description', with: ''
        fill_in 'product_position', with: ''
        within '.actions' do
          click_button '変更する'
        end

        expect(page).to have_content '変更に失敗しました'
        expect(page).to have_css 'h1', text: '商品編集'
      end
    end

    it '商品詳細画面へ遷移する' do
      visit edit_admin_product_path(product)
      click_on '戻る'

      expect(page).to have_css 'h1', text: '商品詳細(管理画面)'
    end

    it 'トップ画面へ遷移する' do
      visit edit_admin_product_path(product)
      click_on 'トップ'

      expect(page).to have_css 'h1', text: '商品一覧(管理画面)'
    end
  end

  describe '商品一覧' do
    let!(:product) { create(:product, name: 'にんじん', price: 1_000, description: '商品説明です。') }

    it '商品情報が表示される' do
      visit admin_root_path

      expect(page).to have_css 'h1', text: '商品一覧(管理画面)'
      expect(page).to have_content 'にんじん'
      expect(page).to have_content '1,000円'
      expect(page).to have_css 'img.product-image'
    end

    it '商品登録画面へ遷移する' do
      click_on '商品登録画面'

      expect(page).to have_css 'h1', text: '商品登録'
    end

    it '商品詳細画面へ遷移する' do
      visit admin_root_path
      click_on 'にんじん'

      expect(page).to have_css 'h1', text: '商品詳細(管理画面)'
    end
  end

  describe '商品詳細' do
    let!(:product) { create(:product, name: 'にんじん', price: 1_000, description: '商品説明です。') }

    it '商品情報が表示される' do
      visit admin_product_path(product)

      expect(page).to have_css 'h1', text: '商品詳細'
      expect(page).to have_content 'にんじん'
      expect(page).to have_content '1,000円'
      expect(page).to have_content '商品説明です。'
      expect(page).to have_css 'img.product-image'
    end

    it 'トップ画面へ遷移する' do
      visit admin_product_path(product)
      click_on 'トップ'

      expect(page).to have_css 'h1', text: '商品一覧(管理画面)'
    end

    it '商品編集画面へ遷移する' do
      visit admin_product_path(product)
      click_on '編集'

      expect(page).to have_css 'h1', text: '商品編集'
    end
  end
end
