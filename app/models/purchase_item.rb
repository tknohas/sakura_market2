class PurchaseItem < ApplicationRecord
  belongs_to :purchase
  belongs_to :product

  def item_total
    product.price * amount
  end
end
