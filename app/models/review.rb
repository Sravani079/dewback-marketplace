# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  comment    :text
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  dewback_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_reviews_on_dewback_id  (dewback_id)
#  index_reviews_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (dewback_id => dewbacks.id)
#  fk_rails_...  (user_id => users.id)
#
class Review < ApplicationRecord
  belongs_to :user
  belongs_to :dewback

  has_one_attached :image  # ✅ Add this line to enable image upload

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true
end

