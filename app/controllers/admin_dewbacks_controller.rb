class AdminDewbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_dewback, only: [:edit, :update]

  def new
    @dewback = Dewback.new
  end

  def create
    @dewback = Dewback.new(dewback_params)
    if @dewback.save
      redirect_to catalog_index_path, notice: "Dewback created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @dewback.update(dewback_params)
      redirect_to catalog_index_path, notice: "Dewback updated."
    else
      render :edit
    end
  end

  private

  def set_dewback
    @dewback = Dewback.find(params[:id])
  end

  def dewback_params
    params.require(:dewback).permit(
      :title, :color, :size, :max_speed, :max_load,
      :food_requirements, :price, :quantity, :description,
      :image_file, :on_sale, :discounted_price
    )
  end  

  def require_admin
    redirect_to root_path unless current_user.admin?
  end
end
