class AddAvailableForTradeToOwners < ActiveRecord::Migration[7.1]
  def change
    add_column :owners, :available_for_trade, :boolean, default: false
  end
end
