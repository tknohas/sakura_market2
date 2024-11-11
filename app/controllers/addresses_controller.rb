class AddressesController < ApplicationController
  before_action :set_address, only: %i[edit update]

  def new
    @address = current_user.build_address
  end

  def create
    @address = current_user.build_address(address_params)
    if @address.save
      redirect_to new_purchase_path, notice: '登録しました'
    else
      flash.now[:alert] = '登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @address.update(address_params)
      redirect_to new_purchase_path, notice: '変更しました'
    else
      flash.now[:alert] = '変更に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def address_params
    params.require(:address).permit(:zip_code, :prefecture, :city, :street, :building)
  end

  def set_address
    @address = current_user.address
  end
end
