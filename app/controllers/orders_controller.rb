class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.includes(:order_status,
                                           :order_items).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @order = current_user.orders.includes(:order_items).find(params[:id])
  end
end
