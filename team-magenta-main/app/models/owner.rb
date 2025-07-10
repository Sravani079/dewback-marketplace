# == Schema Information
#
# Table name: owners
#
#  id                  :bigint           not null, primary key
#  available_for_trade :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  dewback_id          :bigint           not null
#  order_id            :bigint
#  user_id             :bigint           not null
#
# Indexes
#
#  index_owners_on_dewback_id              (dewback_id)
#  index_owners_on_order_id                (order_id)
#  index_owners_on_user_id                 (user_id)
#  index_owners_on_user_id_and_dewback_id  (user_id,dewback_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (dewback_id => dewbacks.id)
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (user_id => users.id)
#
# app/models/owner.rb
class Owner < ApplicationRecord
  belongs_to :user
  belongs_to :dewback
  belongs_to :order, optional: true

  # Whether the dewback owned is up for trade
  attribute :available_for_trade, :boolean, default: false
end

