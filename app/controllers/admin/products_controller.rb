class Admin::ProductsController < Admin::ApplicationController
  before_action :set_product, only: %i[edit update]

  def index
    @products = Product.order(created_at: :desc)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_root_path, notice: '登録しました'
    else
      flash.now[:alert] = '登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to admin_root_path, notice: '変更しました'
    else
      flash.now[:alert] = '変更に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description, :private, :position)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
