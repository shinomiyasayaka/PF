class Favorite < ApplicationRecord

  belongs_to :customer
  belongs_to :post
  has_one :notification, as: :notifiable, dependent: :destroy

  validates_uniqueness_of :post_id, scope: :customer_id

end
