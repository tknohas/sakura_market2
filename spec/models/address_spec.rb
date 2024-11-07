RSpec.describe Address, type: :model do
  let(:user) { create(:user) }
  subject { described_class.new(user:, zip_code: '145-0071', prefecture: '東京都', city: '大田区', street: '田園調布2-62') }

  describe 'バリデーション' do
    it 'バリデーションが有効' do
      expect(subject).to be_valid
    end

    describe '郵便番号' do
      it 'バリデーションが無効(入力なし)' do
        subject.zip_code = nil
        expect(subject).to_not be_valid
      end

      it 'バリデーションが無効(文字数)' do
        subject.zip_code = '1450-0071'
        expect(subject).to_not be_valid
      end

      it 'バリデーションが無効(ハイフンなし)' do
        subject.zip_code = '1450071'
        expect(subject).to_not be_valid
      end

      it 'バリデーションが無効(形式)' do
        subject.zip_code = '14-50071'
        expect(subject).to_not be_valid
      end
    end

    describe '都道府県' do
      it 'バリデーションが無効(入力なし)' do
        subject.prefecture = nil
        expect(subject).to_not be_valid
      end

      it 'バリデーションが無効(文字数)' do
        subject.prefecture = '鹿児島県県'
        expect(subject).to_not be_valid
      end

      it 'バリデーションが無効(最後の文字が都道府県のいずれでもない)' do
        subject.prefecture = '東京'
        expect(subject).to_not be_valid
      end
    end

    describe '市区町村' do
      it 'バリデーションが無効(入力なし)' do
        subject.city = nil
        expect(subject).to_not be_valid
      end

      it 'バリデーションが無効(文字数)' do
        subject.city = 'a' * 51
        expect(subject).to_not be_valid
      end
    end

    describe 'それ以後の住所' do
      it 'バリデーションが無効(入力なし)' do
        subject.street = nil
        expect(subject).to_not be_valid
      end

      it 'バリデーションが無効(文字数)' do
        subject.street = 'a' * 101
        expect(subject).to_not be_valid
      end
    end

    it '建物名が不正' do
      subject.building = 'a' * 101
        expect(subject).to_not be_valid
    end
  end
end
