class CartsController < ApplicationController
  before_action :authenticate_user!

  def add_to_cart
    cart = current_user.cart || current_user.create_cart
    cart_item = cart.cart_items.find_or_initialize_by(dewback_id: params[:dewback_id])
    cart_item.quantity ||= 0
    cart_item.quantity += 1

    if cart_item.save
      redirect_to dewback_path(params[:dewback_id]), notice: "Dewback added to cart!"
    else
      redirect_to dewback_path(params[:dewback_id]), alert: "Could not add to cart."
    end
  end

  def show
    cart = current_user.cart || current_user.create_cart
    @cart_items = cart.cart_items.includes(:dewback)
  end

  def update
    cart = current_user.cart
    if params[:items].present?
      params[:items].each do |item_id, item_data|
        item = cart.cart_items.find_by(id: item_id)
        next unless item
        item.update(quantity: item_data[:quantity].to_i)
      end
      redirect_to cart_path, notice: "Cart updated."
    else
      redirect_to cart_path, alert: "No items to update."
    end
  end

  def destroy
    cart = current_user.cart
    if cart
      cart.cart_items.destroy_all
    end
    redirect_to cart_path, notice: 'Cart emptied.'
  end

  def reorder
    order = current_user.orders.find(params[:order_id])
    cart = current_user.cart || current_user.create_cart

    cart.cart_items.destroy_all

    dewback_names = order.dewback_name.to_s.split(",").map(&:strip)

    dewback_names.each do |title|
      dewback = Dewback.find_by(title: title)
      cart.cart_items.create!(dewback: dewback, quantity: 1) if dewback
    end

    redirect_to cart_path, notice: "Dewbacks added back to your cart successfully!"
  end
end
