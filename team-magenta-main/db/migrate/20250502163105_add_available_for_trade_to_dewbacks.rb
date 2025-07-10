class AddAvailableForTradeToDewbacks < ActiveRecord::Migration[7.1]
  def change
    add_column :dewbacks, :available_for_trade, :boolean
  end
end
