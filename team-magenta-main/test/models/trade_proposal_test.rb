# == Schema Information
#
# Table name: trade_proposals
#
#  id                         :bigint           not null, primary key
#  status                     :string           default("pending")
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  original_trade_proposal_id :integer
#  proposer_id                :bigint
#  recipient_id               :bigint
#
# Indexes
#
#  index_trade_proposals_on_original_trade_proposal_id  (original_trade_proposal_id)
#  index_trade_proposals_on_proposer_id                 (proposer_id)
#  index_trade_proposals_on_recipient_id                (recipient_id)
#
# Foreign Keys
#
#  fk_rails_...  (proposer_id => users.id)
#  fk_rails_...  (recipient_id => users.id)
#
require "test_helper"

class TradeProposalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
