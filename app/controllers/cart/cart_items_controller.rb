class Cart::CartItemsController < ApplicationController
  skip_before_action :authenticate_user!
  
  def create
    product = Product.find(params[:product_id])
    amount = params[:cart_item][:amount].to_i
    if current_cart.add_or_update_cart_item(product, amount)
      redirect_to root_path, notice: 'カートに商品を追加しました'
    end
  end

  def destroy
    cart_item = current_cart.cart_items.find(params[:id])
    cart_item.destroy!
    redirect_to cart_path, notice: '商品を削除しました'
  end
end
