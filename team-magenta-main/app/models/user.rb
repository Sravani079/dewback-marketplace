# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_one :cart
  has_many :reviews
  has_many :orders, dependent: :destroy

  has_many :owned_dewbacks,
           class_name: 'Dewback',
           foreign_key: 'owner_id',
           dependent: :nullify

  # Trade proposal relationships
  has_many :proposed_trades,
           class_name: 'TradeProposal',
           foreign_key: 'proposer_id',
           dependent: :destroy

  has_many :received_trades,
           class_name: 'TradeProposal',
           foreign_key: 'recipient_id',
           dependent: :destroy

  has_many :owners
  has_many :owned_dewbacks, through: :owners, source: :dewback

  has_many :wishlists, dependent: :destroy    # wishlist associations
  has_many :wishlisted_dewbacks,
           through: :wishlists,
           source: :dewback
  
  has_one  :cart, dependent: :destroy

  # Cart utility
  def cart_item_count
    cart&.cart_items&.sum(:quantity) || 0
  end

  def admin?
    self.admin
  end

  has_many :notifications, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }


 
end
