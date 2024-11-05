class Cart::CartItemsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    amount = params[:cart_item][:amount].to_i
    if current_cart.add_or_update_cart_item(product, amount)
      redirect_to cart_path, notice: 'カートに商品を追加しました'
    end
  end
end
