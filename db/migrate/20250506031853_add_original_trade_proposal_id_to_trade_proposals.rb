class AddOriginalTradeProposalIdToTradeProposals < ActiveRecord::Migration[6.1]
  def change
    add_column :trade_proposals, :original_trade_proposal_id, :integer
    add_index :trade_proposals, :original_trade_proposal_id
  end
end
