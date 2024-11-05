class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @products = Product.order(:created_at)
  end
end
