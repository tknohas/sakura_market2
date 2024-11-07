class Admin::ProductsController < Admin::ApplicationController
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      # TODO: 商品一覧画面を設定後、path変更
      redirect_to root_path, notice: '登録しました'
    else
      flash.now[:alert] = '登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description, :private, :position)
  end
end
