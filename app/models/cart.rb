class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_or_update_cart_item(product, amount)
    cart_item = cart_items.find_or_initialize_by(product:)
    cart_item.amount += amount
    cart_item.save
  end

  BASE_SHIPPING_FEE = 600
  ITEMS_PER_TIER = 5
  TAX_RATE = 1.1

  def subtotal
    cart_items.sum(&:item_total)
  end

  def calculate_shipping_fee
    BASE_SHIPPING_FEE * (cart_items.sum(:amount) / ITEMS_PER_TIER.to_f).ceil
  end

  def total_price
    ((subtotal + calculate_shipping_fee) * TAX_RATE).floor
  end

  def calculate_tax
    (total_price - (subtotal + calculate_shipping_fee)).floor
  end
end
