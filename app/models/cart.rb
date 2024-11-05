class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_or_update_cart_item(product, amount)
    cart_item = cart_items.find_or_initialize_by(product:)
    cart_item.amount += amount
    cart_item.save
  end
end
