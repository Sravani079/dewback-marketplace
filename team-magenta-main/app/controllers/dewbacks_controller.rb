class DewbacksController < ApplicationController
  before_action :authenticate_user!, only: [:my_dewbacks]

  def show
    @dewback = Dewback.find(params[:id])
    @wishlist = current_user.wishlists.find_by(dewback_id: @dewback.id) if user_signed_in?
  
  end

  def my_dewbacks
    @my_dewbacks = current_user.owners.includes(:dewback).map(&:dewback)
  end
end