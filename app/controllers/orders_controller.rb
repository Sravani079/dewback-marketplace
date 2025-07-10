class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @order = Order.new
    @cart_items = current_user.cart&.cart_items&.includes(:dewback) || []
    @saved_payment_methods = current_user.payment_methods
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user

    cart_items = current_user.cart&.cart_items&.includes(:dewback) || []

    @order.dewback_name = cart_items.map { |item| item.dewback.title }.join(", ")
    @order.number_of_items = cart_items.sum(&:quantity)

    selected_type = params[:payment_method_type]

    # ✅ 1. Use saved card if selected
    if params[:saved_payment_method_id].present?
      saved_method = current_user.payment_methods.find_by(id: params[:saved_payment_method_id])
      @order.payment_method = saved_method if saved_method
    end

    # ✅ 2. Handle new credit/debit card entry
    if selected_type.in?(%w[credit_card debit_card]) && params[:saved_payment_method_id].blank?
      last4 = params[:card_number].to_s.last(4)
      exp_month, exp_year = parse_expiry(params[:expiry_date])
      token = "tok_#{SecureRandom.hex(8)}"

      if params[:save_payment_method] == "1"
        saved_method = current_user.payment_methods.find_or_create_by!(
          last4: last4,
          exp_month: exp_month,
          exp_year: exp_year,
          method_type: selected_type
        ) do |pm|
          pm.provider = "manual"
          pm.token = token
        end
      else
        saved_method = PaymentMethod.create!(
          user: current_user,
          method_type: selected_type,
          token: token,
          last4: last4,
          exp_month: exp_month,
          exp_year: exp_year,
          provider: "temp"
        )
      end

      @order.payment_method = saved_method
    end

    # ✅ 3. Handle PayPal
    if selected_type == "paypal"
      saved_method = current_user.payment_methods.find_or_create_by!(
        method_type: "paypal",
        provider: "paypal"
      ) do |pm|
        pm.token = "paypal_#{SecureRandom.hex(6)}"
        pm.last4 = "N/A"
      end
      @order.payment_method = saved_method
    end

    # ❌ Final validation check
    if @order.payment_method.blank?
      flash.now[:alert] = "Please provide a valid payment method."
      @cart_items = cart_items
      @saved_payment_methods = current_user.payment_methods
      render :new, status: :unprocessable_entity and return
    end

    if @order.save
      current_user.cart.cart_items.destroy_all
      redirect_to confirmation_order_path(@order)
    else
      @cart_items = cart_items
      @saved_payment_methods = current_user.payment_methods
      render :new, status: :unprocessable_entity
    end
  end

  def confirmation
    @order = Order.find(params[:id])
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:name, :address, :delivery_method)
  end

  def parse_expiry(expiry_str)
    return [nil, nil] if expiry_str.blank? || !expiry_str.include?("/")
    parts = expiry_str.split("/")
    month = parts[0].to_i
    year = parts[1].length == 2 ? "20#{parts[1]}" : parts[1]
    [month, year.to_i]
  end
end
