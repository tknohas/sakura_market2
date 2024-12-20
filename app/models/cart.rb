class Cart < ApplicationRecord
  belongs_to :user, optional: true
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

  def cash_on_delivery_fee
    case subtotal
    when 0...10000
      300
    when 10000...30000
      400
    when 30000...100000
      600
    else
      1000
    end
  end

  def total_before_tax
    subtotal + calculate_shipping_fee + cash_on_delivery_fee
  end

  def total_price
    (total_before_tax * TAX_RATE).floor
  end

  def calculate_tax
    (total_price - total_before_tax).floor
  end

  def merge_guest_cart_items(session_cart_id)
    guest_cart = Cart.find_by(id: session_cart_id)
    return unless guest_cart

    transaction do
      guest_cart.cart_items.each do |guest_item|
        exiting_item = cart_items.find_by(product_id: guest_item.product_id)
        if exiting_item
          exiting_item.update(amount: exiting_item.amount + guest_item.amount)
        else
          cart_items.create(product_id: guest_item.product_id, amount: guest_item.amount)
        end
      end
      guest_cart.destroy!
    end
  end
end
