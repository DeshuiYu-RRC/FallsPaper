class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def retry_payment
    @order = current_user.orders.find(params[:id])
    
    unless @order.pending?
      flash[:alert] = "This order has already been processed."
      redirect_to order_path(@order) and return
    end

    # Redirect to checkout with pre-filled data
    redirect_to checkout_path(order_id: @order.id)
  end
end