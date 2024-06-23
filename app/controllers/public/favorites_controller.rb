class Public::FavoritesController < ApplicationController
  before_action :authenticate_customer!
  def index
    customer = Customer.find(params[:customer_id])
    @favorite_posts = customer.favorite_posts.page(params[:page]).order(created_at: :desc)
    @post = Post.find(params[:customer_id])
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
end
