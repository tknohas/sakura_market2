class AddressesController < ApplicationController
  def new
    @address = current_user.build_address
  end

  def create
    @address = current_user.build_address(address_params)
    if @address.save
      redirect_to new_purchase_path, notice: '登録しました'
    else
      flash.now[:alert] = '変更に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def address_params
    params.require(:address).permit(:zip_code, :prefecture, :city, :street, :building)
  end
end