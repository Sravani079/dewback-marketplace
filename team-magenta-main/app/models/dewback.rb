# == Schema Information
#
# Table name: dewbacks
#
#  id                  :bigint           not null, primary key
#  available_for_trade :boolean
#  color               :string
#  description         :text
#  discounted_price    :decimal(, )
#  food_requirements   :string
#  image               :string
#  max_load            :string
#  max_speed           :string
#  on_sale             :boolean          default(FALSE)
#  price               :decimal(, )
#  quantity            :integer
#  size                :string
#  title               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :bigint
#
# Indexes
#
#  index_dewbacks_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
class Dewback < ApplicationRecord
  belongs_to :owner, class_name: 'User', optional: true
  belongs_to :order, optional: true

  has_many :reviews
  has_many :cart_items

  # Associations for Trade Proposals
  has_many :offered_dewbacks
  has_many :requested_dewbacks

  has_many :owners
  has_many :users, through: :owners

  has_many :wishlists, dependent: :destroy   # wishlist associations
  has_many :wishers,
           through: :wishlists,
           source: :user

  # Optionally, to directly get the current owner (assuming one-to-one trade):
  has_one :current_owner, -> { where(available_for_trade: true) }, class_name: "Owner"

  has_one_attached :image_file

  validates :discounted_price, numericality: { greater_than: 0 }, allow_nil: true

  FILTER_OPTIONS = {
    size: ["Small", "Medium", "Large"],
    max_speed: ["Slow", "Moderate", "Fast"],
    max_load: ["Light", "Moderate", "Heavy"],
    food_requirements: ["Low", "Moderate", "High"],
    color: ["Green", "Brown", "Olive"]
  }.freeze

  SORTABLE_FIELDS = {
    speed: :max_speed,
    size: :size,
    load: :max_load
  }.freeze

  # 🔍 Search by title or color
  def self.search(query)
    where("title ILIKE :q OR color ILIKE :q", q: "%#{query}%")
  end

  def display_price
    on_sale && discounted_price.present? ? discounted_price : price
  end

  # ✅ Safe predicate method
  def available_for_trade?
    respond_to?(:available_for_trade) && !!available_for_trade
  end
end
