class Product < ApplicationRecord
  has_one_attached :image
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items
  has_many :purchase_items, dependent: :destroy
  has_many :purchases, through: :purchase_items

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :position, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
end
