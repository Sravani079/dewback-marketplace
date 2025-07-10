class AddOwnerToDewbacks < ActiveRecord::Migration[7.1]
  def change
    add_reference :dewbacks, :owner,foreign_key:{ to_table: :users }, null: true, index: true
  end
end
