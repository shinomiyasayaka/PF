class Public::RelationshipsController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_guest_customer, only: [:create]

  def create
    @customer = Customer.find(params[:customer_id])
    current_customer.follow(@customer)
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    current_customer.unfollow(@customer)
  end

  private
  def ensure_guest_customer
    @customer = current_customer
    if @customer.guest_customer?
      redirect_to list_path, notice: "ゲストユーザーはフォローできません。"
    end
  end

end
