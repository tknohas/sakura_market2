class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.order(:id)
  end
end
