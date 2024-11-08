class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @products = Product.order_by_position
  end
end
