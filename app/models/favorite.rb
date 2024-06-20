class Favorite < ApplicationRecord

  belongs_to :customer
  belongs_to :post
  has_one :notification, as: :notifiable, dependent: :destroy

  validates_uniqueness_of :post_id, scope: :customer_id

  after_create do
    create_notification(customer_id: post.customer_id)
  end

end
