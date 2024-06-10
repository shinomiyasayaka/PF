class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post

  has_many :customer_rooms
  has_many :chats
  has_many :rooms, through: :customer_rooms
  has_many :view_counts, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  has_one_attached :profile_image

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(customer)
    relationships.create(followed_id: customer.id)
  end

  def unfollow(customer)
    relationships.find_by(followed_id: customer.id).destroy
  end

  def following?(customer)
    followings.include?(customer)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Customer.where(name: content)
    elsif method == 'forward'
      Customer.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      Customer.where('name LIKE ?', '%' + content)
    else
      Customer.where('name LIKE ?', '%' + content + '%')
    end
  end


  def customer_status
    if is_active == true
      "有効"
    else
      "退会"
    end
  end

  def active_for_authentication?
    super && (is_active == true)
  end

  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = "guestuser"
    end
  end

  def guest_customer?
    email == GUEST_USER_EMAIL
  end

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :email, presence: true

end
