class Address < ApplicationRecord
  belongs_to :user

  validates :zip_code, presence: true, length: { maximum: 8 }, format: { with: /\d{3}-\d{4}/ }
  validates :prefecture, presence: true, length: { maximum: 4 }, format: { with: /[都道府県]\z/, message: 'まで入力してください' }
  validates :city, presence: true, length: { maximum: 50 }
  validates :street, presence: true, length: { maximum: 100 }
  validates :building, length: { maximum: 100 }
end
