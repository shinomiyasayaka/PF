class Admin::CustomersController < ApplicationController

  before_action :authenticate_admin!

  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      if @customer.is_active == false
        redirect_to admin_customer_path(@customer), notice: '会員情報が更新されました。'
      else
        redirect_to admin_customer_path(@customer), notice: '会員情報が更新されました。'
      end
    else
      render :edit
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :profile_image, :is_active)
  end

end
