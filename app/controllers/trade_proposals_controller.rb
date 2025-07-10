class TradeProposalsController < ApplicationController
  before_action :authenticate_user!

  def new
    @recipient_dewback = Dewback.find_by(id: params[:dewback_id])

    if @recipient_dewback.nil?
      redirect_to trade_market_path, alert: "Dewback not found."
      return
    end

    owner_record = Owner.find_by(dewback: @recipient_dewback)
    if owner_record.nil?
      redirect_to trade_market_path, alert: "Cannot propose trade: Dewback has no owner."
      return
    end

    @recipient = owner_record.user

    @my_dewbacks = current_user.owners
                               .includes(:dewback)
                               .where(available_for_trade: true)
                               .map(&:dewback)

    @trade_proposal = TradeProposal.new
  end

  def create
    recipient_user = User.find_by(id: params[:recipient_id])

    proposal = TradeProposal.new(
      proposer: current_user,
      recipient: recipient_user,
      status: "pending"
    )

    if proposal.save
      Array(params[:offered_dewback_ids]).each do |id|
        proposal.offered_dewbacks.create(dewback_id: id)
      end

      if params[:recipient_dewback_id].present?
        proposal.requested_dewbacks.create(dewback_id: params[:recipient_dewback_id])
      end

      # ✅ Notification to recipient only
      Notification.create!(
        user: recipient_user,
        message: "📬 You have a new trade proposal from #{current_user.name || current_user.email}",
        read: false,
        notifiable: proposal
      )

      redirect_to trade_market_path, notice: "Trade proposed successfully."
    else
      redirect_to trade_market_path, alert: "Trade proposal could not be saved."
    end
  end

  def counter
    @original_proposal = TradeProposal.find(params[:id])

    if @original_proposal.recipient != current_user
      redirect_to trade_inbox_path, alert: "You are not authorized to counter this trade."
      return
    end

    @my_dewbacks = current_user.owners
                               .includes(:dewback)
                               .where(available_for_trade: true)
                               .map(&:dewback)

    @counter_proposal = TradeProposal.new(
      proposer: current_user,
      recipient: @original_proposal.proposer,
      status: "pending",
      original_trade_proposal_id: @original_proposal.id
    )
  end

  def create_counter
    original = TradeProposal.find(params[:original_id])
    counter_recipient = original.proposer

    counter = TradeProposal.new(
      proposer: current_user,
      recipient: counter_recipient,
      original_trade_proposal_id: original.id,
      status: "pending"
    )

    if counter.save
      Array(params[:offered_dewback_ids]).each do |id|
        counter.offered_dewbacks.create(dewback_id: id)
      end

      Array(params[:requested_dewback_ids]).each do |id|
        counter.requested_dewbacks.create(dewback_id: id)
      end

      # ✅ Notification to original proposer only (the recipient of this counter)
      Notification.create!(
        user: counter_recipient,
        message: "♻️ You have received a counter trade proposal from #{current_user.name || current_user.email}",
        read: false,
        notifiable: counter
      )

      redirect_to trade_inbox_path, notice: "Counter-proposal sent successfully."
    else
      redirect_to trade_inbox_path, alert: "Failed to send counter-proposal."
    end
  end
end
