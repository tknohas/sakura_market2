class Purchase < ApplicationRecord
  before_create :set_calculated_attributes

  belongs_to :user
  has_many :purchase_items, dependent: :destroy
  has_many :products, through: :purchase_items

  accepts_nested_attributes_for :purchase_items

  def set_calculated_attributes
    assign_attributes(
      subtotal: user.cart.subtotal,
      shipping_fee: user.cart.calculate_shipping_fee,
      delivery_fee: user.cart.cash_on_delivery_fee,
      tax: user.cart.calculate_tax,
      total_price: user.cart.total_price,
    )
  end
end
