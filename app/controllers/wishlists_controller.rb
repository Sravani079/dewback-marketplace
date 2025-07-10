class WishlistsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wishlisted_dewbacks = current_user.wishlisted_dewbacks
  end

  def create
    dewback = Dewback.find_by(id: params[:dewback_id])
    unless dewback
      flash[:alert] = "Dewback not found"
      redirect_to dewback_catalog_path and return
    end

    if current_user.wishlists.exists?(dewback: dewback)
      flash[:alert] = 'Dewback is already in your wishlist.'
      redirect_to dewback_path(dewback)
    else
      wishlist = current_user.wishlists.build(dewback: dewback)
      if wishlist.save
        flash[:success] = 'Dewback added to your wishlist.'
        redirect_to dewback_path(dewback)
      else
        flash[:alert] = 'Could not add dewback to wishlist.'
        redirect_to dewback_path(dewback)
      end
    end
  end

  def destroy
    wishlist = current_user.wishlists.find_by(id: params[:id])
    if wishlist
      wishlist.destroy
      flash[:success] = 'Dewback removed from your wishlist.'
      redirect_to wishlists_path
    else
      flash[:alert] = 'Wishlist item not found.'
      redirect_to wishlists_path
    end
  end
end
