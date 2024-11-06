RSpec.describe Purchase, type: :model do
  let(:user) { create(:user) }
  subject { described_class.new(user:, subtotal: 0, shipping_fee: 0, delivery_fee: 0, tax: 0, total_price: 0, delivery_time: '指定なし') }

  describe 'バリデーション' do
    it 'バリデーションが有効' do
      expect(subject).to be_valid
    end

    describe '営業日' do
      it 'バリデーションが有効(3営業日)' do
        subject.delivery_date = 3.business_days.after(Date.current)
        expect(subject).to be_valid
      end

      it 'バリデーションが有効(14営業日)' do
        subject.delivery_date = 14.business_days.after(Date.current)
        expect(subject).to be_valid
      end

      it 'バリデーションが無効(2営業日)' do
        subject.delivery_date = 2.business_days.after(Date.current)
        expect(subject).to_not be_valid
      end

      it 'バリデーションが無効(15営業日)' do
        subject.delivery_date = 15.business_days.after(Date.current)
        expect(subject).to_not be_valid
      end
    end
  end
end
