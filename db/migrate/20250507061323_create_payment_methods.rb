class CreatePaymentMethods < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_methods do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider
      t.string :token
      t.string :method_type
      t.string :last4
      t.integer :exp_month
      t.integer :exp_year

      t.timestamps
    end
  end
end
