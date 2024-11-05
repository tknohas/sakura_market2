RSpec.describe CartItem, type: :model do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:cart) { create(:cart, user:) }
  subject { described_class.new(cart:, product:, amount: 1) }

  describe 'バリデーション' do
    it 'バリデーションが有効' do
      expect(subject).to be_valid
    end

    describe '数量' do
      it '0より小さいと無効' do
        subject.amount = -1
        expect(subject).to_not be_valid
      end

      it '数値以外は無効' do
        subject.amount = 'あ'
        expect(subject).to_not be_valid
      end
    end
  end
end
