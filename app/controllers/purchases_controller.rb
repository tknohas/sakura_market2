class PurchasesController < ApplicationController
  def new
  end

  def create
    @purchase = current_user.purchases.build(purchase_params)
    if @purchase.save
      current_cart.cart_items.destroy_all
      redirect_to root_path, notice: '購入が完了しました'
    else
      render :new
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(purchase_items_attributes: [:product_id, :amount])
  end
end
