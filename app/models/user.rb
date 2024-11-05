class User < ApplicationRecord
  has_one :cart, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
end
