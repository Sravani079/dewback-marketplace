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
require "test_helper"

class DewbackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
