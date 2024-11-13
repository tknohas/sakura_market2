class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users = User.order(:id)
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: '変更しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_path, notice: '削除しました'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
