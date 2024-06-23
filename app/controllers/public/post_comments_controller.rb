class Public::PostCommentsController < ApplicationController
   before_action :ensure_guest_customer, only: [:create]

  def create
    @post = Post.find(params[:post_id])
    @comment = current_customer.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    @comment.save
    @post_comments = @post.post_comments
  end

  def destroy
    @comment = PostComment.find(params[:id])
    @comment.destroy
    @post = Post.find(params[:post_id])
    @post_comments = @post.post_comments
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

  def ensure_guest_customer
    @customer = current_customer
    if @customer.guest_customer?
      redirect_to posts_path, notice: "ゲストユーザーはコメントできません。"
    end
  end

end
