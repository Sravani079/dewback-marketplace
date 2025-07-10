# == Schema Information
#
# Table name: orders
#
#  id                :bigint           not null, primary key
#  address           :text
#  delivery_method   :string
#  dewback_name      :string
#  name              :string
#  number_of_items   :integer
#  payment_method    :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  payment_method_id :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_orders_on_payment_method_id  (payment_method_id)
#  index_orders_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (payment_method_id => payment_methods.id)
#  fk_rails_...  (user_id => users.id)
#
class Order < ApplicationRecord
  belongs_to :user
  has_many :owners
  belongs_to :payment_method, optional: true
  has_many :dewbacks, through: :owners

  DELIVERY_METHODS = %w[shipping pickup]

  validates :delivery_method,
            presence: true,
            inclusion: { in: DELIVERY_METHODS }

  validates :address, presence: true

  after_create :assign_dewback_ownership

  private

  def assign_dewback_ownership
    return if user.nil? || dewback_name.blank?
    dewback_name.to_s.split(', ').each do |title|
      next if title.blank?

      dewback = Dewback.find_by(title: title.strip)
      Owner.find_or_create_by(user: user, dewback: dewback) if dewback
    end
  end
end
