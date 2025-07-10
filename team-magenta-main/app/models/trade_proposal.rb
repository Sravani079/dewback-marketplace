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
class TradeProposal < ApplicationRecord
  belongs_to :proposer, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  has_many :offered_dewbacks
  has_many :requested_dewbacks
  belongs_to :original_trade_proposal, class_name: "TradeProposal", optional: true
  has_many :counter_proposals, class_name: "TradeProposal", foreign_key: :original_trade_proposal_id
end
