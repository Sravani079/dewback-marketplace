class AddFieldsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :dewback_name, :string
    add_column :orders, :number_of_items, :integer
  end
end
