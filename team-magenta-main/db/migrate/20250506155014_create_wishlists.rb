class CreateWishlists < ActiveRecord::Migration[7.1]
  def change
    create_table :wishlists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :dewback, null: false, foreign_key: true

      t.timestamps
    end
    add_index :wishlists, [:user_id, :dewback_id], unique: true
  end
end
