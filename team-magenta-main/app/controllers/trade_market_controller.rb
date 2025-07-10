class TradeMarketController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @dewbacks = Dewback
                  .joins(:owners)
                  .includes(:owners => :user)
                  .where(owners: { available_for_trade: true })
                  .distinct
                  .order(:title)
  end
end
