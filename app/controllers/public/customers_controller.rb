class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update]
  before_action :ensure_guest_customer, only: [:edit]


  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts.page(params[:page])
  end

  def index
    @customers = Customer.page(params[:page]).order(created_at: :desc)
  end

  def edit
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to mypage_path(@customer), notice: "会員情報を更新しました。"
    else
      render "edit"
    end
  end

  def unsubscribe
  end

  def withdraw
    @customer = Customer.find(current_customer.id)
    @customer.update(is_active: false)
    # is_activeカラムをfalseに変更する
    reset_session
    # 退会した時点でログアウトする
    flash[:notice] = "退会処理を実行いたしました。"
    redirect_to root_path
  end

  def followings
    @customer = Customer.find(params[:customer_id])
    @customers = @customer.followings.page(params[:page])
  end

  def followers
    @customer = Customer.find(params[:customer_id])
    @customers = @customer.followers.page(params[:page])
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :email, :profile_image)
  end

  def ensure_correct_customer
    @customer = current_customer
    unless @customer == current_customer
      redirect_to customer_path(current_customer)
    end
  end

  def ensure_guest_customer
    @customer = current_customer
    if @customer.guest_customer?
      redirect_to mypage_path(current_customer) , notice: "ゲストユーザーは会員編集できません。"
    end
  end

end
