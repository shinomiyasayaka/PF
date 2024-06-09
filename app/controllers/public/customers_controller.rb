class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update]


  def show
    @customer = current_customer
    @posts = @customer.posts
  end

  def index
    @customers = Customer.all
  end

  def favorite

  end

  def edit
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to mypage_path(@customer), notice: "You have updated user successfully."
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
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :profile_image)
  end

  def ensure_correct_customer
    @customer = current_customer
    unless @customer == current_customer
      redirect_to customer_path(current_customer)
    end
  end

end
