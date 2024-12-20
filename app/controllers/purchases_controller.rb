class PurchasesController < ApplicationController
  def index
    @purchases = current_user.purchases.order(created_at: :desc)
  end

  def new
    @purchase = Purchase.build(product_ids: current_cart.product_ids)
  end

  def create
    @purchase = current_user.purchases.build(purchase_params)
    if @purchase.save
      current_cart.cart_items.destroy_all
      redirect_to root_path, notice: '購入が完了しました'
    else
      flash.now[:alert] = '購入に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @purchase = current_user.purchases.find(params[:id])
  end

  private

  def purchase_params
    params.require(:purchase).permit(:delivery_date, :delivery_time, purchase_items_attributes: %i[product_id amount])
  end
end
