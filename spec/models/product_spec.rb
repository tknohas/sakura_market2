RSpec.describe Product, type: :model do
  let(:product) { create(:product) }
  subject { described_class.new(name: 'にんじん', price: 1_000, description: '商品説明です。', private: false) }

  describe 'バリデーション' do
    it 'バリデーションが有効' do
      expect(subject).to be_valid
    end

    describe '商品名' do
      it '入力なし' do
        subject.name = nil
        expect(subject).to_not be_valid
      end

      it '文字数が多い' do
        subject.name = 'a' * 51
        expect(subject).to_not be_valid
      end
    end

    describe '価格' do
      it '入力なし' do
        subject.price = nil
        expect(subject).to_not be_valid
      end

      it '負の値を入力' do
        subject.price = -1
        expect(subject).to_not be_valid
      end

      it '数値以外を入力' do
        subject.price = 'あ'
        expect(subject).to_not be_valid
      end
    end

    describe '商品説明' do
      it '入力なし' do
        subject.name = nil
        expect(subject).to_not be_valid
      end

      it '文字数が多い' do
        subject.name = 'a' * 501
        expect(subject).to_not be_valid
      end
    end

    describe '表示順' do
      it '負の値を入力' do
        subject.price = -1
        expect(subject).to_not be_valid
      end

      it '数値以外を入力' do
        subject.price = 'あ'
        expect(subject).to_not be_valid
      end
    end
  end
end
