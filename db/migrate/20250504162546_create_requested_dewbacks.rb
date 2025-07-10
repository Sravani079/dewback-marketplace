class CreateRequestedDewbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :requested_dewbacks do |t|
      t.references :trade_proposal, null: false, foreign_key: true
      t.references :dewback, null: false, foreign_key: true

      t.timestamps
    end
  end
end
