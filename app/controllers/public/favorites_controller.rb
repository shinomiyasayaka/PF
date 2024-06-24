class Public::FavoritesController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_guest_customer, only: [:create, :index]

  def index
    customer = Customer.find(params[:customer_id])
    @favorite_posts = customer.favorite_posts.page(params[:page]).order(created_at: :desc)
  end

  def create
    @post = Post.find(params[:post_id])
    favorite = current_customer.favorites.new(post_id: @post.id)
    favorite.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_customer.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end

  private
  def ensure_guest_customer
    @customer = current_customer
    if @customer.guest_customer?
      if action_name == "create"
        redirect_to posts_path, notice: "ゲストユーザーはいいねできません。"
      elsif action_name == "index"
        redirect_to mypage_path(current_customer), notice: "ゲストユーザーはお気に入り一覧を使用できません。"
      end
    end
  end

end
