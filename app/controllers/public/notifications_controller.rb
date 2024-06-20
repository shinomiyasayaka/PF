class Public::NotificationsController < ApplicationController
  before_action :authenticate_customer!

  def update
    notification = current_customer.notifications.find(params[:id])
    notification.update(read: true)
    # 通知の種類によるリダイレクトパスの生成
    case notification.notifiable_type
    when "Post"
      redirect_to post_path(notification.notifiable)
    else
      redirect_to mypage_path(notification.notifiable.customer)
    end
  end

end
