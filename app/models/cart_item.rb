class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :cart_id, uniqueness: { scope: :product_id }
  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def item_total
    product.price * amount
  end
end
