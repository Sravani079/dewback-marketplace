class CreateTradeProposals < ActiveRecord::Migration[7.1]
  def change
    create_table :trade_proposals do |t|
      t.references :proposer, foreign_key: { to_table: :users }
      t.references :recipient, foreign_key: { to_table: :users }
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
