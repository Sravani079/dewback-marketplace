  class TradeInboxController < ApplicationController
    before_action :authenticate_user!
    before_action :set_proposal, only: [:show, :accept, :reject]
    before_action :authorize_recipient!, only: [:show, :accept, :reject]
  
    def index
      @proposals = TradeProposal.where(recipient: current_user).order(created_at: :desc)
    end
  
    def show
      @proposal = TradeProposal.find(params[:id])
      unless @proposal.recipient == current_user
        redirect_to trade_inbox_index_path, alert: "Access denied." and return
      end
    end
  
    def accept
      TradeProposal.transaction do
        # Transfer offered dewbacks: proposer → recipient
        @proposal.offered_dewbacks.each do |od|
          dewback = od.dewback
          Owner.find_by(user: @proposal.proposer, dewback: dewback)&.destroy
          Owner.create!(user: @proposal.recipient, dewback: dewback, available_for_trade: false)
        end
  
        # Transfer requested dewbacks: recipient → proposer
        @proposal.requested_dewbacks.each do |rd|
          dewback = rd.dewback
          Owner.find_by(user: @proposal.recipient, dewback: dewback)&.destroy
          Owner.create!(user: @proposal.proposer, dewback: dewback, available_for_trade: false)
        end
  
        @proposal.update!(status: "accepted")
  
        # ✅ Also reject original proposal if this is a counter
        @proposal.original_trade_proposal&.update!(status: "rejected")
      end
  
      redirect_to trade_inbox_path, notice: "Trade accepted successfully."
    rescue => e
      redirect_to trade_proposal_details_path(@proposal), alert: "Trade could not be accepted: #{e.message}"
    end
  
    def reject
      @proposal.update!(status: "rejected")
  
      # ✅ Also reject original proposal if this is a counter
      @proposal.original_trade_proposal&.update!(status: "rejected")
  
      redirect_to trade_inbox_path, notice: "Trade rejected successfully."
    end
  
    private
  
    def set_proposal
      @proposal = TradeProposal.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to trade_inbox_path, alert: "Trade proposal not found."
    end
  
    def authorize_recipient!
      redirect_to trade_inbox_path, alert: "Access denied." unless @proposal.recipient == current_user
    end
  end
  