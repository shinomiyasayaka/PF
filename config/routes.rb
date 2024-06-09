Rails.application.routes.draw do

  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  root to: "public/homes#top"

  # 顧客側ルーティング
  scope module: :public do
    resources :customers, only: [] do
      member do
        resource :relationships, only: [:create, :destroy]
        get "followings" => "relationships#followings", as: "followings"
        get "followers" => "relationships#followers", as: "followers"
      end
    end

    scope '/customers' do
      get 'my_page' => 'customers#show', as: 'mypage'
      get 'list' => 'customers#index', as: 'list'
      get 'favorites' => 'customers#favorite', as: 'favorite'
      get 'information/edit' => 'customers#edit', as: 'edit_information'
      patch 'information' => 'customers#update', as: 'update_information'
      get 'unsubscribe' => 'customers#unsubscribe', as: 'confirm_unsubscribe'
      patch 'withdraw' => 'customers#withdraw', as: 'withdraw_customer'
    end

    resources :posts, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end

    post 'chats' => 'chats#create'
    get 'chats/room' => 'chats#show', as: 'chat'
    get '/search', to: 'searches#search'
    resources :notifications, only: [:update]
  end

  # 管理者側ルーティング
  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    resources :posts, only: [:index, :show, :edit, :update, :destroy]
    resources :customers, only: [:index, :show, :edit, :update]
  end


end
