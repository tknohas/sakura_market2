class User < ApplicationRecord
  has_one :cart, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :purchases, dependent: :restrict_with_exception

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
end
