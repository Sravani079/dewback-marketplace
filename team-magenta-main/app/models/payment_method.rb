# == Schema Information
#
# Table name: payment_methods
#
#  id          :bigint           not null, primary key
#  exp_month   :integer
#  exp_year    :integer
#  last4       :string
#  method_type :string
#  provider    :string
#  token       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_payment_methods_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
# app/models/payment_method.rb
class PaymentMethod < ApplicationRecord
  belongs_to :user

  validates :method_type, presence: true
  validates :exp_month, presence: true, unless: :paypal?
  validates :exp_year, presence: true, unless: :paypal?

  def paypal?
    method_type == "paypal"
  end

  def to_s
    if paypal?
      "PayPal"
    else
      "#{method_type.titleize} ending in #{last4} (exp #{exp_month}/#{exp_year})"
    end
  end
end


