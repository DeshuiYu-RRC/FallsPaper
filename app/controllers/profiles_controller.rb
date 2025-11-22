class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @recent_orders = current_user.orders.includes(:order_status).order(created_at: :desc).limit(5)
  end

  def edit
    @user = current_user
    @provinces = Province.order(:name)
  end

  def update
    @user = current_user
    @provinces = Province.order(:name)

    if @user.update(profile_params)
      flash[:notice] = "Profile updated successfully."
      redirect_to profile_path
    else
      flash.now[:alert] = "Error updating profile."
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username, :phone, :address, :city, :postal_code, :province_id)
  end
end
