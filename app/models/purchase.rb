class Purchase < ApplicationRecord
  before_create :set_calculated_attributes

  belongs_to :user
  has_many :purchase_items, dependent: :destroy
  has_many :products, through: :purchase_items

  accepts_nested_attributes_for :purchase_items

  validates :delivery_time, presence: true
  validate :delivery_date_should_be_within_valid_range

  def set_calculated_attributes
    assign_attributes(
      subtotal: user.cart.subtotal,
      shipping_fee: user.cart.calculate_shipping_fee,
      delivery_fee: user.cart.cash_on_delivery_fee,
      tax: user.cart.calculate_tax,
      total_price: user.cart.total_price
    )
  end

  DELIVERY_TIME_OPTIONS = [
    '指定なし',
    '8:00~12:00',
    '12:00~14:00',
    '14:00~16:00',
    '16:00~18:00',
    '18:00~20:00',
    '20:00~21:00',
  ].map { |time| [time, time] }.freeze

  def delivery_time_options
    DELIVERY_TIME_OPTIONS
  end

  def delivery_date_should_be_within_valid_range
    return if delivery_date.blank?

    unless delivery_date.between?(3.business_days.after(Date.current), 14.business_days.after(Date.current))
      errors.add(:delivery_date, 'は3営業日から14営業日までの範囲で指定可能です。')
    end
  end
end
