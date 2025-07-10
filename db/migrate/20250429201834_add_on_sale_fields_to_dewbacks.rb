class AddOnSaleFieldsToDewbacks < ActiveRecord::Migration[7.1]
  def change
    add_column :dewbacks, :on_sale, :boolean, default: false
    add_column :dewbacks, :discounted_price, :decimal
  end
end
