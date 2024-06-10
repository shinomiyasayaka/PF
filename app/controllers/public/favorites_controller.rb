class Public::FavoritesController < ApplicationController
  def index
    customer = Customer.find(params[:customer_id])
    @favorite_posts = customer.favorite_posts
  end

  def create
    post = Post.find(params[:post_id])
    favorite = current_customer.favorites.new(post_id: post.id)
    favorite.save
    redirect_to request.referer
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = current_customer.favorites.find_by(post_id: post.id)
    favorite.destroy
    redirect_to request.referer
  end
end
