class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @products = Product.includes(:image_attachment).order_by_position
  end
end
