class AddOrderIdToOwners < ActiveRecord::Migration[7.1]
  def change
    add_reference :owners, :order, null: true, foreign_key: true
  end
end
