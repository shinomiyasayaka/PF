class Public::PostsController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    unless ViewCount.find_by(customer_id: current_customer.id, post_id: @post.id)
      current_customer.view_counts.create(post_id: @post.id)
    end
    @post_comment = PostComment.new
    @post_comments = @post.post_comments
  end

  def index
    @posts = Post.all
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    if @post.save
      redirect_to post_path(@post), notice: "投稿を保存しました。"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿内容を更新しました。"
    else
      render "edit"
    end
  end

  def destroy
    @post.destroy
    redirect_to mypage_path(current_customer)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end

  def ensure_correct_customer
    @post = Post.find(params[:id])
    unless @post.customer == current_customer
      redirect_to posts_path
    end
  end

end
