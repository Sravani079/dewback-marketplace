class MyDewbacksController < ApplicationController
  before_action :authenticate_user!

  def index
    # Fetch owner records of dewbacks the current user owns
    @owned_dewbacks = current_user.owners.includes(:dewback).order(created_at: :desc)
  end

  def mark_for_trade
    owner = current_user.owners.find_by(dewback_id: params[:id])
    if owner&.update(available_for_trade: true)
      redirect_to my_dewbacks_path, notice: 'Dewback marked as available for trade.'
    else
      redirect_to my_dewbacks_path, alert: 'Could not mark dewback for trade.'
    end
  end
  
  def remove_from_trade
    owner = current_user.owners.find_by(dewback_id: params[:id])
    if owner&.update(available_for_trade: false)
      redirect_to my_dewbacks_path, notice: 'Dewback removed from trade.'
    else
      redirect_to my_dewbacks_path, alert: 'Could not remove dewback from trade.'
    end
  end
  
end
